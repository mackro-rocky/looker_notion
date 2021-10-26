# The name of this view in Looker is "Model States Sensor Raw"
view: model_states_sensor_raw {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."MODEL_STATES_SENSOR_RAW"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Data" in Explore.

  dimension: data {
    type: string
    sql: ${TABLE}."DATA" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: data_received {
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
    sql: CAST(${TABLE}."DATA_RECEIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: filename {
    type: string
    sql: ${TABLE}."FILENAME" ;;
  }

  dimension: listener_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."LISTENER_ID" ;;
  }

  dimension: observation_id {
    type: string
    sql: ${TABLE}."OBSERVATION_ID" ;;
  }

  dimension: payload {
    type: string
    sql: ${TABLE}."PAYLOAD" ;;
  }

  dimension: previous_model_state_id {
    type: string
    sql: ${TABLE}."PREVIOUS_MODEL_STATE_ID" ;;
  }

  dimension: sensor_message_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."SENSOR_MESSAGE_ID" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [filename, listeners.id, sensor_messages.id, sensor_messages.filename]
  }
}

# These sum and average measures are hidden by default.
# If you want them to show up in your explore, remove hidden: yes.
