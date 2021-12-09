

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
        FROM  "PC_STITCH_DB"."SNOWFLAKE_POC"."SENSORS_ALL" sen
                 JOIN "PC_STITCH_DB"."SNOWFLAKE_POC"."HARDWARE_SENSORS" hws ON sen.hardware_id = hws.id
        -- WHERE sen.system_id NOTNULL
        GROUP BY sen.system_id
    ),
         -- add an supplemental system_id through sensors.last_bridge_hardware_id b/c some bridges are lonely
         supplemented_bridges AS (
             SELECT  bridges.*,
                                             CASE
                                                 WHEN bridges.system_id IS NOT NULL THEN bridges.system_id
                                                 ELSE sensor_systems.system_id END AS supplemented_system_id
             FROM "PC_STITCH_DB"."SNOWFLAKE_POC"."BRIDGES_ALL" bridges

                      JOIN "PC_STITCH_DB"."SNOWFLAKE_POC"."HARDWARE_BRIDGES" hwb ON bridges.hardware_id = hwb.id
                      LEFT JOIN (
                 SELECT DISTINCT sensors.last_bridge_hardware_id, sensors.system_id
                 FROM "PC_STITCH_DB"."SNOWFLAKE_POC"."SENSORS_ALL" sensors
             ) sensor_systems ON hwb.id = sensor_systems.last_bridge_hardware_id
             QUALIFY ROW_NUMBER() OVER (PARTITION BY bridges.id ORDER BY bridges.id) = 1
         ),
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
                      JOIN "PC_STITCH_DB"."SNOWFLAKE_POC"."HARDWARE_BRIDGES" hwb ON bri.hardware_id = hwb.id
             -- WHERE bri.supplemented_system_id NOTNULL
             GROUP BY bri.supplemented_system_id
         )
    SELECT sys.id,
           sys.uuid,
           sys.created_at,
           sys.deleted_at,
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
FROM system_status ;;
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
