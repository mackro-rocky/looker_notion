# The name of this view in Looker is "Hardware Sensors"
view: hardware_sensors {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PC_STITCH_DB"."SNOWFLAKE_POC"."HARDWARE_SENSORS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
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

  dimension: country_code {
    type: string
    sql: ${TABLE}."COUNTRY_CODE" ;;
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

  dimension: creator_id {
    type: string
    sql: ${TABLE}."CREATOR_ID" ;;
  }

  dimension: hardware_type {
    type: number
    sql: ${TABLE}."HARDWARE_TYPE" ;;
  }

  dimension: mac_address_pan {
    type: number
    sql: ${TABLE}."MAC_ADDRESS_PAN" ;;
  }

  dimension: revision {
    type: number
    sql: ${TABLE}."REVISION" ;;
  }

  dimension: serial_number {
    type: string
    sql: ${TABLE}."SERIAL_NUMBER" ;;
  }

  dimension: temp_offset {
    type: number
    sql: ${TABLE}."TEMP_OFFSET" ;;
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

  dimension: has_loveland {
    type: yesno
    sql: BOOLOR(case ${TABLE}."REVISION" when 3 then 1 else 0 end , 0) ;;
  }
  dimension: has_granite {
    type: yesno
    sql: BOOLOR(case ${TABLE}."REVISION" when 4 then 1 else 0 end , 0) ;;
  }
  dimension: has_breck {
    type: yesno
    sql: BOOLOR(case ${TABLE}."REVISION" when 5 then 1 when 6 then 1 else 0 end , 0) ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
  measure: serial_number_count {
    type: count_distinct
    sql: ${serial_number} ;;
  }
  measure: max_hws_revision {
    type: max
    sql: ${revision} ;;
  }
}
