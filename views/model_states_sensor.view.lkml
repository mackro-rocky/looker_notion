# The name of this view in Looker is "Model States Sensor"
view: model_states_sensor {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."MODEL_STATES_SENSOR"
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

  dimension: model_type {
    type: string
    sql: replace(${TABLE}.payload:model_type,'"','') ;;

  }

  dimension: previous_model_state_id {
    type: string
    sql: ${TABLE}."PREVIOUS_MODEL_STATE_ID" ;;
  }

  dimension: sensor_message_id {
    type: string
    sql: ${TABLE}."SENSOR_MESSAGE_ID" ;;
  }


  measure: count {
    type: count
    drill_fields: [filename]
  }
}
