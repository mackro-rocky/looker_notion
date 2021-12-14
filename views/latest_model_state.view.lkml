# The name of this view in Looker is "Latest Model State"
view: latest_model_state {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."LATEST_MODEL_STATE"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

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
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Data" in Explore.

  dimension: data {
    type: string
    sql: ${TABLE}."DATA" ;;
  }


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

  dimension: hardware_id {
    type: string
    sql: ${TABLE}."HARDWARE_ID" ;;
  }

  dimension: listener_id {
    type: string
    sql: ${TABLE}."LISTENER_ID" ;;
  }

  dimension: model_version {
    type: string
    sql: ${TABLE}."MODEL_VERSION" ;;
  }

  dimension: sensor_uuid {
    type: string
    sql: ${TABLE}."SENSOR_UUID" ;;
  }

  dimension: task_type_id {
    type: number
    sql: ${TABLE}."TASK_TYPE_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  # dimension: payload {
  #   type: string
  #   sql: ${TABLE}."PAYLOAD" ;;
  # }

  # dimension: hardware_flavor {
  #   type: string
  #   sql: ${TABLE}. payload:hardware_flavor::string ;;
  # }

  # dimension: model_type {
  #   type: string
  #   sql: ${TABLE}.payload:model_type::string ;;

  # }

  dimension: waterleak_state {
    type: string
    sql: case ${task_type_id} when 4 then
            coalesce(${TABLE}."DATA":state:probe, ${TABLE}."DATA":state)
            else null end;;
    # sql: case ${model_type} when 'waterleak' then case replace(payload:hardware_flavor,'"','')
    #           when 'breck' then   replace(replace(payload:data:state::string,'{"probe":"',''),'"}','')
    #           when 'granite' then payload:data:state::string else payload:data:state::string end else null end ;;
  }

  dimension: vertical_hinged_door_state {
    type: string
    sql: case when ${task_type_id} in (5, 6, 12) then ${TABLE}."DATA":state:door
            else null end;;
  }

  dimension: vertical_hinged_magnet_state {
    type: string
    sql: case when ${task_type_id} in (5, 6, 12) then ${TABLE}."DATA":state:magnet
            else null end;;
  }

  dimension: vertical_hinged_period_state {
    type: string
    sql: case when ${task_type_id} in (5, 6, 12) then ${TABLE}."DATA":state:magnet
            else null end;;
  }

  dimension: garage_door_state {
    type: string
    sql: case when ${task_type_id} in (13, 16) then ${TABLE}."DATA":state:door
    else null end;;
  }

  dimension: sliding_door_state {
    type: string
    sql: case ${task_type_id} when 32 then
      coalesce(${TABLE}."DATA":state:door, ${TABLE}."DATA":state)
      else null end;;
  }

  # dimension: sensor_connection_state {
  #   type: string
  #   sql: case ${model_type} when 'sensor_connection' then   payload:data:bridge_online::string
  #     else null end ;;
  # }

  dimension: battery_state {
    type: string
    sql: case ${task_type_id} when 0 then ${TABLE}."DATA":state:battery
      else null end;;
  }
  dimension: battery_decay {
    type: string
    sql: case ${task_type_id} when 0 then ${TABLE}."DATA":state:decay
    else null end;;
  }

  # dimension: battery_transition {
  #   type: string
  #   sql: case ${model_type} when 'battery' then   data:transition::string
  #     else null end ;;
  # }

  dimension: alarm_state {
    type: string
    sql: case ${task_type_id} when 7 then
      coalesce(${TABLE}."DATA":state:alarm, ${TABLE}."DATA":state:alarm)
      else null end;;
  }
  # dimension: alarm_transition {
  #   type: string
  #   sql: case ${model_type} when 'alarm' then   data:transition::string
  #     else null end ;;
  # }

}
