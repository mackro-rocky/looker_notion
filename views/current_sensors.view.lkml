view: current_sensors {
  derived_table: {
    sql: SELECT s.*
    FROM "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SENSORS_ALL" s
    QUALIFY ROW_NUMBER() OVER (PARTITION BY s.hardware_id ORDER BY s.installed_at DESC NULLS LAST) = 1 ;;
  }

    dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: calibrated {
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
    sql: CAST(${TABLE}."CALIBRATED_AT" AS TIMESTAMP_NTZ) ;;
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

  dimension: firmware_version {
    type: string
    sql: ${TABLE}."FIRMWARE_VERSION" ;;
  }

  dimension: hardware_id {
    type: string
    sql: ${TABLE}."HARDWARE_ID" ;;
  }

  dimension: hardware_revision {
    type: number
    sql: ${TABLE}."HARDWARE_REVISION" ;;
  }

  dimension_group: installed {
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
    sql: CAST(${TABLE}."INSTALLED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_bridge_hardware_id {
    type: string
    sql: ${TABLE}."LAST_BRIDGE_HARDWARE_ID" ;;
  }

  dimension_group: last_reported {
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
    sql: CAST(${TABLE}."LAST_REPORTED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension_group: missing {
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
    sql: CAST(${TABLE}."MISSING_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: surface_type_id {
    type: string
    sql: ${TABLE}."SURFACE_TYPE_ID" ;;
  }

  dimension: system_id {
    type: number
    sql: ${TABLE}."SYSTEM_ID" ;;
  }

  dimension_group: updated {
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
    sql: CAST(${TABLE}."UPDATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: uuid {
    type: string
    sql: ${TABLE}."UUID" ;;
  }

  dimension: hours_missing {
    type: number
    sql:  COALESCE(DATEDIFF(hour, ${TABLE}.missing_at, CURRENT_TIMESTAMP), 0) ;;
  }

  dimension: status {
    type:  string
    sql: CASE
          WHEN ${TABLE}.deleted_at IS NOT NULL THEN 'deleted'
          WHEN ${TABLE}.installed_at IS NULL THEN 'lonely'
          WHEN ${TABLE}.missing_at IS NULL THEN 'active'
          WHEN ${hours_missing} <= 24 THEN 'lost'
          WHEN ${hours_missing} <= 30*24 THEN 'dormant'
          WHEN ${hours_missing} <= 90*24 THEN 'churned'
          ELSE 'abandoned' END ;;
  }
}
