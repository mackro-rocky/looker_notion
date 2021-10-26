# The name of this view in Looker is "Task Types"
view: task_types {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."TASK_TYPES"
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
  # This dimension will be called "Available Versions" in Explore.

  dimension: available_versions {
    type: number
    sql: ${TABLE}."AVAILABLE_VERSIONS" ;;
  }

  dimension: configuration_options {
    type: string
    sql: ${TABLE}."CONFIGURATION_OPTIONS" ;;
  }

  dimension: conflict_type {
    type: string
    sql: ${TABLE}."CONFLICT_TYPE" ;;
  }

  dimension: conflicting_types {
    type: string
    sql: ${TABLE}."CONFLICTING_TYPES" ;;
  }

  dimension: default_version {
    type: number
    sql: ${TABLE}."DEFAULT_VERSION" ;;
  }

  dimension: hardware_configuration {
    type: string
    sql: ${TABLE}."HARDWARE_CONFIGURATION" ;;
  }

  dimension: hidden {
    type: yesno
    sql: ${TABLE}."HIDDEN" ;;
  }

  dimension: input_compatibility {
    type: number
    sql: ${TABLE}."INPUT_COMPATIBILITY" ;;
  }

  dimension: model_type {
    type: string
    sql: ${TABLE}."MODEL_TYPE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: observation_info {
    type: string
    sql: ${TABLE}."OBSERVATION_INFO" ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension: priority {
    type: number
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: resources {
    type: string
    sql: ${TABLE}."RESOURCES" ;;
  }

  dimension: routing_key {
    type: string
    sql: ${TABLE}."ROUTING_KEY" ;;
  }

  dimension: suppress_alerts {
    type: yesno
    sql: ${TABLE}."SUPPRESS_ALERTS" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_available_versions {
    type: sum
    hidden: yes
    sql: ${available_versions} ;;
  }

  measure: average_available_versions {
    type: average
    hidden: yes
    sql: ${available_versions} ;;
  }

  measure: total_default_version {
    type: sum
    hidden: yes
    sql: ${default_version} ;;
  }

  measure: average_default_version {
    type: average
    hidden: yes
    sql: ${default_version} ;;
  }

  measure: total_input_compatibility {
    type: sum
    hidden: yes
    sql: ${input_compatibility} ;;
  }

  measure: average_input_compatibility {
    type: average
    hidden: yes
    sql: ${input_compatibility} ;;
  }

  measure: total_priority {
    type: sum
    hidden: yes
    sql: ${priority} ;;
  }

  measure: average_priority {
    type: average
    hidden: yes
    sql: ${priority} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      listeners.count,
      listeners_bridge_all.count,
      listeners_integration_all.count,
      listeners_nest_thermostat_all.count,
      listeners_sensor_all.count,
      listeners_system_all.count,
      listeners_system_users_all.count,
      listeners_user_all.count
    ]
  }
}
