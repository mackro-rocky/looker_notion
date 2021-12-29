

 view: system_stats {
#   # Or, you could make this view a derived table, like this:
 derived_table: {
    sql:
    WITH system_status AS (
    WITH sensors_by_system AS (
        SELECT sen.system_id,
               count(sen.hardware_id)                                                         AS num_sensors_ever,
               count(iff (sen.deleted_at IS NULL, sen.id,null))                               AS num_undeleted_sensors,
               count(iff ((sen.missing_at IS NULL AND sen.deleted_at IS NULL),sen.id,null))   AS num_active_sensors,
               MIN(sen.installed_at)                                                          AS first_sensor_installed_at,
               CASE
                   WHEN count(iff (sen.deleted_at IS NOT NULL, sen.id,null)) > 0 THEN NULL
                   ELSE MAX(sen.deleted_at) END                                               AS last_sensor_deleted_at,

               CASE
                   WHEN count(iff(sen.missing_at IS NULL AND sen.deleted_at IS NULL,sen.id,null)) > 0 THEN NULL
                   ELSE MAX(sen.missing_at) END                                               AS last_sensor_missing_at,
               MAX(hws.revision)                                                              AS max_hws_revision
        FROM  "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SENSORS_ALL" sen
                 JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."HARDWARE_SENSORS" hws ON sen.hardware_id = hws.id
        WHERE sen.deleted_at IS NULL
        GROUP BY sen.system_id
    ),
         -- add an supplemental system_id through sensors.last_bridge_hardware_id b/c some bridges are lonely
         supplemented_bridges AS (
             SELECT  bridges.*,
                                             CASE
                                                 WHEN bridges.system_id IS NOT NULL THEN bridges.system_id
                                                 ELSE sensor_systems.system_id END AS supplemented_system_id
             FROM "PC_STITCH_DB"."PRODUCTION_APPLICATION"."BRIDGES_ALL" bridges

                      JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."HARDWARE_BRIDGES" hwb ON bridges.hardware_id = hwb.id
                      LEFT JOIN (
                 SELECT DISTINCT sensors.last_bridge_hardware_id, sensors.system_id
                 FROM "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SENSORS_ALL" sensors WHERE sensors.deleted_at IS NULL
             ) sensor_systems ON hwb.id = sensor_systems.last_bridge_hardware_id
                WHERE  bridges.deleted_at IS NULL
             QUALIFY ROW_NUMBER() OVER (PARTITION BY bridges.id ORDER BY bridges.id) = 1
         ) ,
         bridges_by_system AS (
             SELECT bri.supplemented_system_id                                                     AS system_id,
                    count(bri.hardware_id)                                                         AS num_bridges_ever,

                    count(iff (bri.deleted_at IS NULL, bri.id,null))                               AS num_undeleted_bridges,

                    count(iff ((bri.missing_at IS NULL AND bri.deleted_at IS NULL),bri.id,null))   AS num_active_bridges,

                    MIN(bri.created_at)                                                            AS first_bridge_created_at,

                   CASE
                        WHEN count(iff (bri.deleted_at IS NOT NULL, bri.id,null)) > 0 THEN NULL
                   ELSE MAX(bri.deleted_at) END                                                    AS last_bridge_deleted_at,
                   CASE
                     WHEN count(iff(bri.missing_at IS NULL AND bri.deleted_at IS NULL,bri.id,null)) > 0 THEN NULL
                   ELSE MAX(bri.missing_at) END                                                    AS last_bridge_missing_at,

                    MAX(hwb.revision)                                                              AS max_hwb_revision
             FROM supplemented_bridges bri
                      JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."HARDWARE_BRIDGES" hwb ON bri.hardware_id = hwb.id
             -- WHERE bri.supplemented_system_id NOTNULL
             GROUP BY bri.supplemented_system_id
         )
    SELECT sys.id,
           sys.uuid,
           sys.created_at,
           sys.deleted_at,
           sys.administrative_area,
           sbs.num_sensors_ever,
           sbs.num_undeleted_sensors,
           sbs.num_active_sensors,
           sbs.first_sensor_installed_at,
           sbs.last_sensor_deleted_at,
           sbs.last_sensor_missing_at,
           bbs.num_bridges_ever,
           bbs.num_undeleted_bridges,
           bbs.num_active_bridges,
           bbs.first_bridge_created_at,
           bbs.last_bridge_deleted_at,
           bbs.last_bridge_missing_at,
           GREATEST(bbs.max_hwb_revision + 1, sbs.max_hws_revision) AS max_hw_revision,
           CASE
               WHEN bbs.num_bridges_ever IS NULL THEN 'no bridge installed'
               WHEN sys.timezone_id = 'Asia/Tokyo' THEN 'sony'
               WHEN GREATEST(bbs.max_hwb_revision + 1, sbs.max_hws_revision) <= 3 THEN 'loveland only'
               WHEN sbs.num_sensors_ever IS NULL THEN 'no sensors installed'
               WHEN sys.deleted_at IS NOT NULL THEN 'system deleted'
               WHEN bbs.num_undeleted_bridges = 0 THEN 'bridges deleted'
               WHEN sbs.num_undeleted_sensors = 0 THEN 'sensors deleted'
               WHEN bbs.num_active_bridges = 0 AND sbs.num_active_sensors > 0 THEN 'zombies'
               WHEN sbs.num_active_sensors > 0 THEN 'active'
               WHEN sbs.last_sensor_missing_at >= current_timestamp() - INTERVAL '24 hours' THEN 'missing'
               WHEN sbs.last_sensor_missing_at >= current_timestamp() - INTERVAL '30 days' THEN 'dormant'
               WHEN sbs.last_sensor_missing_at >= current_timestamp() - INTERVAL '90 days' THEN 'churned'
               ELSE 'abandoned' END                                 AS status
    FROM "PC_STITCH_DB"."SNOWFLAKE_POC"."SYSTEMS_ALL"  sys
             LEFT JOIN sensors_by_system sbs ON sys.id = sbs.system_id
             LEFT JOIN bridges_by_system bbs ON sys.id = bbs.system_id
)
SELECT
           id,
           uuid,
           administrative_area,
           created_at,
           deleted_at,
           num_sensors_ever,
           num_undeleted_sensors,
           num_active_sensors,
           first_sensor_installed_at,
           last_sensor_deleted_at,
           last_sensor_missing_at,
           num_bridges_ever,
           num_undeleted_bridges,
           num_active_bridges,
           first_bridge_created_at,
           last_bridge_deleted_at,
           last_bridge_missing_at,
           max_hw_revision,
           status
FROM system_status;;
  }

#
#   # Define your dimensions and measures here, like this:
  dimension: id {
     type: number
     sql: ${TABLE}.id ;;
   }
  dimension: uuid {
    type: string
    sql: ${TABLE}.uuid ;;
  }
  dimension: administrative_area {
    type: string
    sql: ${TABLE}.administrative_area ;;
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: deleted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."DELETED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension: num_sensors_ever {
    type: number
    sql: ${TABLE}.num_sensors_ever ;;
  }
  dimension: num_undeleted_sensors {
    type: number
    sql: ${TABLE}.num_undeleted_sensors ;;
  }
  dimension: num_active_sensors {
    type: number
    sql: ${TABLE}.num_active_sensors ;;
  }
  dimension_group: first_sensor_installed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."FIRST_SENSOR_INSTALLED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: last_sensor_deleted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_SENSOR_DELETED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: last_sensor_missing {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_SENSOR_MISSING_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension: num_bridges_ever {
    type: number
    sql: ${TABLE}.num_bridges_ever ;;
  }
  dimension: num_undeleted_bridges {
    type: number
    sql: ${TABLE}.num_undeleted_bridges ;;
  }
  dimension: num_active_bridges {
    type: number
    sql: ${TABLE}.num_active_bridges ;;
  }

  dimension_group: first_bridge_created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."FIRST_BRIDGE_CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: last_bridge_deleted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_BRIDGE_DELETED_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: last_bridge_missing {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_BRIDGE_MISSING_AT" AS TIMESTAMP_NTZ) ;;
  }
  dimension: max_hw_revision {
    type: string
    sql: ${TABLE}.max_hw_revision ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  measure: retained_system_count{
    type: number
    sql: count(iff (status IN ('active', 'missing', 'dormant', 'churned'),${TABLE}."ID",null)) ;;
  }
  measure: installed_system_count{
    type: number
    sql: count(iff (status IN ('active', 'missing', 'dormant', 'churned', 'abandoned', 'zombies','sensors deleted', 'bridges deleted', 'system deleted'),${TABLE}."ID",null)) ;;
  }
  measure: active{
    type: number
    sql: count(iff (status = 'active',${TABLE}."ID",null)) ;;
  }
  measure: missing{
    type: number
    sql: count(iff (status = 'missing',${TABLE}."ID",null)) ;;
  }
  measure: dormant{
    type: number
    sql: count(iff (status = 'dormant',${TABLE}."ID",null)) ;;
  }
  measure: churned{
    type: number
    sql: count(iff (status = 'churned',${TABLE}."ID",null)) ;;
  }
  measure: abandoned{
    type: number
    sql: count(iff (status = 'abandoned',${TABLE}."ID",null)) ;;
  }
  measure: zombies{
    type: number
    sql: count(iff (status = 'zombies',${TABLE}."ID",null)) ;;
  }
  measure: sensors_deleted{
    type: number
    sql: count(iff (status = 'sensors deleted',${TABLE}."ID",null)) ;;
  }
  measure: bridges_deleted{
    type: number
    sql: count(iff (status = 'bridges deleted',${TABLE}."ID",null)) ;;
  }
  measure: no_sensors_installed{
    type: number
    sql: count(iff (status = 'no sensors installed',${TABLE}."ID",null)) ;;
  }
  measure: loveland_only{
    type: number
    sql: count(iff (status = 'loveland only',${TABLE}."ID",null)) ;;
  }
  measure: sony{
    type: number
    sql: count(iff (status = 'sony',${TABLE}."ID",null)) ;;
  }
  measure: no_bridge_installed{
    type: number
    sql: count(iff (status = 'no bridge installed',${TABLE}."ID",null)) ;;
  }
  measure: system_deleted{
    type: number
    sql: count(iff (status = 'system deleted',${TABLE}."ID",null)) ;;
  }

}
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
