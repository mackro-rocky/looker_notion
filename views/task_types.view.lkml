# The name of this view in Looker is "Task Types"
view: task_types {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PC_STITCH_DB"."SNOWFLAKE_POC"."TASK_TYPES"
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

  dimension: available_versions {
    type: string
    sql: ${TABLE}."AVAILABLE_VERSIONS" ;;
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
    type: string
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
    type: string
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

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
