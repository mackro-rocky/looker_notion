# The name of this view in Looker is "Sensor Messages"
view: sensor_messages {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SENSOR_MESSAGES"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Bridge Hardware ID" in Explore.

  dimension: bridge_hardware_id {
    type: string
    sql: ${TABLE}."BRIDGE_HARDWARE_ID" ;;
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
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: data {
    type: string
    sql: ${TABLE}."DATA" ;;
  }

  dimension: filename {
    type: string
    sql: ${TABLE}."FILENAME" ;;
  }

  dimension: hardware_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."HARDWARE_ID" ;;
  }

  dimension: lqi {
    type: number
    sql: ${TABLE}."LQI" ;;
  }

  dimension: payload {
    type: string
    sql: ${TABLE}."PAYLOAD" ;;
  }

  dimension_group: persisted {
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
    sql: CAST(${TABLE}."PERSISTED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: received {
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
    sql: CAST(${TABLE}."RECEIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: rssi {
    type: number
    sql: ${TABLE}."RSSI" ;;
  }

  dimension_group: sent {
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
    sql: CAST(${TABLE}."SENT_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: type {
    type: number
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: type_eng {
    type: string
    sql: case ${TABLE}."TYPE" when 4 then 'Active Tasks' when 1048704 then 'Temp' when 1179776 then 'Acceleration' when 1179652 then 'Home Position'
                              when 131200 then 'Battery Voltage' when 1114240 then 'Voltage After Charge' when 1310724 then 'Config Flags'
                              when 1310721 then 'Status' when 1245312 then 'Mag End' when 65552 then 'Status 2'
                              when 1179775 then 'Status 3' when 1441794 then 'Status 4' when 1441798 then 'Status 5' when 1048577 then 'Status 6'
                              when 131073 then 'Status 7' when 1179649 then 'Status 8' when 1245311 then 'Status 9' when 128 then 'Code'
                              when 1310725 then 'Status 10' when 1114113 then 'Status 11' when 1245185 then 'Status 12' when 1114116 then 'High Threshold'
                              when 1179654 then 'Status 13' when 1179650 then 'Status 14'
                              else 'Other' end ;;
  }


  dimension: version {
    type: number
    sql: ${TABLE}."VERSION" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [id, filename, hardware.id, model_states_sensor_raw.count]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_lqi {
    type: sum
    hidden: yes
    sql: ${lqi} ;;
  }

  measure: average_lqi {
    type: average
    hidden: yes
    sql: ${lqi} ;;
  }

  measure: total_rssi {
    type: sum
    hidden: yes
    sql: ${rssi} ;;
  }

  measure: average_rssi {
    type: average
    hidden: yes
    sql: ${rssi} ;;
  }

  measure: total_type {
    type: sum
    hidden: yes
    sql: ${type} ;;
  }

  measure: average_type {
    type: average
    hidden: yes
    sql: ${type} ;;
  }

  measure: total_version {
    type: sum
    hidden: yes
    sql: ${version} ;;
  }

  measure: average_version {
    type: average
    hidden: yes
    sql: ${version} ;;
  }
}
