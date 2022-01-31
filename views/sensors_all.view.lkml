# The name of this view in Looker is "Sensors All"
view: sensors_all {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SENSORS_ALL"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: _sdc_batched {
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
    sql: CAST(${TABLE}."_SDC_BATCHED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: _sdc_received {
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
    sql: CAST(${TABLE}."_SDC_RECEIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called " Sdc Sequence" in Explore.

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}."_SDC_SEQUENCE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total__sdc_sequence {
    type: sum
    sql: ${_sdc_sequence} ;;
  }

  measure: average__sdc_sequence {
    type: average
    sql: ${_sdc_sequence} ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}."_SDC_TABLE_VERSION" ;;
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

  dimension: hardware_id_old {
    type: string
    sql: ${TABLE}."HARDWARE_ID_OLD" ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

# ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      surface_types.id,
      surface_types.name,
      hardware.id,
      locations.id,
      locations.display_name
    ]
  }
}
