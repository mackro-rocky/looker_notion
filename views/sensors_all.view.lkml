# The name of this view in Looker is "Sensors All"
view: sensors_all {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SENSORS_ALL"
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
    sql: ${TABLE}."CALIBRATED_AT" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
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

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Deleted By" in Explore.

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."DELETED_BY" ;;
  }

  dimension: firmware_version {
    type: string
    sql: ${TABLE}."FIRMWARE_VERSION" ;;
  }

  dimension: hardware_id {
    type: string
    # hidden: yes
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
    sql: ${TABLE}."INSTALLED_AT" ;;
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
    sql: ${TABLE}."LAST_REPORTED_AT" ;;
  }

  dimension: location_id {
    type: number
    # hidden: yes
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
    sql: ${TABLE}."MISSING_AT" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: surface_type_id {
    type: string
    # hidden: yes
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
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: uuid {
    type: string
    sql: ${TABLE}."UUID" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: num_sensors_ever {
    type: count_distinct
    sql: ${hardware_id} ;;
  }
  measure: num_undeleted_sensors {
    type: count_distinct
    sql: iff (${TABLE}.deleted_at IS NULL, sen.id,null) ;;
  }
  measure: num_deleted_sensors {
    type: count_distinct
    sql: iff (${TABLE}.deleted_at IS NOT NULL, sen.id,null) ;;
  }
  measure: num_missing_sensors {
    type: count_distinct
    sql: iff (${TABLE}.missing_at IS NOT NULL, sen.id,null) ;;
  }
  measure: num_active_sensors {
    type: count_distinct
    sql: iff(${TABLE}.missing_at IS NULL AND ${TABLE}.deleted_at IS NULL,sen.id,null) ;;
  }
  measure: last_sensor_deleted_at {
    type: max
    sql: CASE
                   WHEN count(iff (${TABLE}.deleted_at IS NOT NULL, sen.id,null)) > 0 THEN NULL
                   ELSE MAX(${TABLE}.deleted_at) END  ;;
  }
  measure: last_sensor_missing_at {
    type: max
    sql: CASE
                   WHEN count(iff(${TABLE}.missing_at IS NULL AND ${TABLE}.deleted_at IS NULL,sen.id,null)) > 0 THEN NULL
                   ELSE MAX(${TABLE}.missing_at) END  ;;
  }
  measure: first_sensor_installed_at {
    type: min
    sql: ${TABLE}.installed_at ;;
  }





  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_hardware_revision {
    type: sum
    hidden: yes
    sql: ${hardware_revision} ;;
  }

  measure: average_hardware_revision {
    type: average
    hidden: yes
    sql: ${hardware_revision} ;;
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
