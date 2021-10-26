# The name of this view in Looker is "Sensor Configurations"
view: sensor_configurations {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SENSOR_CONFIGURATIONS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Active Tasks" in Explore.

  dimension: active_tasks {
    type: string
    sql: ${TABLE}."ACTIVE_TASKS" ;;
  }

  dimension: audio_gain {
    type: number
    sql: ${TABLE}."AUDIO_GAIN" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: enabled_functions {
    type: number
    sql: ${TABLE}."ENABLED_FUNCTIONS" ;;
  }

  dimension: gforce_threshold {
    type: number
    sql: ${TABLE}."GFORCE_THRESHOLD" ;;
  }

  dimension: light_threshold {
    type: number
    sql: ${TABLE}."LIGHT_THRESHOLD" ;;
  }

  dimension: motion_model {
    type: number
    sql: ${TABLE}."MOTION_MODEL" ;;
  }

  dimension: sensor_id {
    type: number
    sql: ${TABLE}."SENSOR_ID" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
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

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [id]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_audio_gain {
    type: sum
    hidden: yes
    sql: ${audio_gain} ;;
  }

  measure: average_audio_gain {
    type: average
    hidden: yes
    sql: ${audio_gain} ;;
  }

  measure: total_enabled_functions {
    type: sum
    hidden: yes
    sql: ${enabled_functions} ;;
  }

  measure: average_enabled_functions {
    type: average
    hidden: yes
    sql: ${enabled_functions} ;;
  }

  measure: total_gforce_threshold {
    type: sum
    hidden: yes
    sql: ${gforce_threshold} ;;
  }

  measure: average_gforce_threshold {
    type: average
    hidden: yes
    sql: ${gforce_threshold} ;;
  }

  measure: total_light_threshold {
    type: sum
    hidden: yes
    sql: ${light_threshold} ;;
  }

  measure: average_light_threshold {
    type: average
    hidden: yes
    sql: ${light_threshold} ;;
  }

  measure: total_motion_model {
    type: sum
    hidden: yes
    sql: ${motion_model} ;;
  }

  measure: average_motion_model {
    type: average
    hidden: yes
    sql: ${motion_model} ;;
  }
}
