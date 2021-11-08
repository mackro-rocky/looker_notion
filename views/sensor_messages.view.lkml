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

  dimension: hex_type {
    type: string
    sql: concat('0x', ltrim(lower(to_char(${TABLE}."TYPE",'XXXXXX')))) ;;
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
                              when 223 then 'Option Code' when 3586 then 'accel' when 241 then 'enabled_functions' when 116 then 'motion mdel'
                              when 0 then 'format' when 255 then 'hardware revision' when 1507457 then 'bins' when 1507456 then 'dominant frequencies'
                              when 1310848 then 'distance traveled' when 21 then 'bridge hw ID' when 115 then 'code 2' when 33 then 'glitch_count'
                              when 16 then 'duration' when 39 then 'period' when 38 then 'debounce time' when 244 then 'gain' when 34 then 'rate'
                              when 35 then 'minimum dB' when 114 then 'code 3' when 12 then 'maximum distance' when 2816 then 'absolute ending angle'
                              when 1507455 then 'status 15' when 17 then 'frequency report' when 10 then 'hall resistance' when 18 then 'frequency report 2'
                              when 19 then 'frequency report 3' when 240 then 'bridge hw ID 2' when 243 then 'bridge hw ID 3' when 252 then 'bridge hw ID 4'
                              else 'Other' end ;;
  }

  dimension: type_eng_2 {
    type: string
    sql: case ${TABLE}."TYPE" when 4 then 'Active Task Report'
  when 128 then 'Boot Report' when 129 then 'Keep Alive'
  when 65552 then 'Connection Start' when 65553 then 'Connection Stop'
  when 131073 then 'Voltage Start' when 131074 then 'Voltage Stop' when 131200 then 'Voltage Report'
  when 1048577 then 'Temperature Start' when 1048578 then 'Temperature Stop' when 1048704 then 'Temperature Report'
  when 1114113 then 'Leak Start' when 1114114 then 'Leak Stop' when 1114116 then 'Leak Read Register' when 1114240 then 'Leak Report'
  when 1179649 then 'VH Start' when 1179650 then 'VH Stop' when 1179652 then 'VH Read Register' when 1179653 then 'VH Force' when 1179654 then 'VH Reset'
  when 1179775 then 'VH|0x7f' when 1179776 then 'VH Report'
  when 1245185 then 'HH Start' when 1245186 then 'HH Stop' when 1245311 then 'HH|0x7f' when 1245312 then 'HH Report'
  when 1310721 then 'Sliding Start' when 1310722 then 'Sliding Stop' when 1310724 then 'Sliding Read Register'
  when 1310725 then 'Sliding Force' when 1310848 then 'Sliding Report'
  when 1441794 then '0x16|0x02' when 1441798 then '0x16|0x06'
  when 1507329 then 'Sound Start' when 1507330 then 'Sound Stop' when 1507332 then 'Sound Read Register'
  when 1507455 then 'Sound|0x7f' when 1507456 then 'Sound v3 Report' when 1507457 then 'Sound v4 Report'
  when 0 then 'Granite Voltage Report' when 4 then 'Granite Temperature Report'
  when 5 then 'Granite Probe Leak' when 8 then 'Granite Probe Short' when 21 then 'Granite Probe Normal'
  when 10 then 'Granite BMX VH Report' when 11 then 'Granite BMX HH report' when 12 then 'Granite Sliding Report'
  when 16 then 'Granite Sound Report 0' when 17 then 'Granite Sound Report 1' when 18 then 'Granite Sound Report 2' when 19 then 'Granite Sound Report 3'
  when 33 then 'Granite Sound Glitch Count' when 34 then 'Granite Sound Rate Report' when 35 then 'Granite Sound Configuration'
  when 38 then 'Granite ST VH Configuration' when 39 then 'Granite ST VH Period'
  when 112 then 'Granite 0x70 Error' when 114 then 'Granite 0x72 Error' when 115 then 'Granite Debug Message'
  when 116 then 'Granite 0x74 motion model' when 223 then 'Granite 0xDF Message Identity'
  when 240 then 'Granite 0xF0' when 241 then 'Granite 0xF1' when 243 then 'Granite g-force threshold' when 244 then 'Granite audio gain'
  when 252 then 'Granite 0xFC motion calibrated' when 255 then 'Granite sensor hw revision'
  when 2816 then 'Granite ST HH Report' when 3586 then 'Granite ST VH Report'
  else cast(${TABLE}."TYPE" as string) end ;;
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

  measure: average_temp {
    type: average
    sql: (${TABLE}.data:temperature/1000 *9/5) + 32;;
  }
  measure: max_received_time {
    type: string
    sql: MAX(${received_time}) ;;
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
