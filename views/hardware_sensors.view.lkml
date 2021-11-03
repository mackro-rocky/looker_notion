# The name of this view in Looker is "Hardware Sensors"
view: hardware_sensors {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."HARDWARE_SENSORS"
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
  # This dimension will be called "Country Code" in Explore.

  dimension: country_code {
    type: string
    sql: ${TABLE}."COUNTRY_CODE" ;;
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



  dimension: serial_number {
    type: string
    sql: ${TABLE}."SERIAL_NUMBER" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
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

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [id]
  }
  measure: serial_number_count {
    type: count_distinct
    sql: ${serial_number} ;;
  }


  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_hardware_type {
    type: sum
    hidden: yes
    sql: ${hardware_type} ;;
  }

  measure: average_hardware_type {
    type: average
    hidden: yes
    sql: ${hardware_type} ;;
  }

  measure: total_mac_address_pan {
    type: sum
    hidden: yes
    sql: ${mac_address_pan} ;;
  }

  measure: average_mac_address_pan {
    type: average
    hidden: yes
    sql: ${mac_address_pan} ;;
  }

  measure: total_revision {
    type: sum
    hidden: yes
    sql: ${revision} ;;
  }

  measure: average_revision {
    type: average
    hidden: yes
    sql: ${revision} ;;
  }

  measure: total_temp_offset {
    type: sum
    hidden: yes
    sql: ${temp_offset} ;;
  }

  measure: average_temp_offset {
    type: average
    hidden: yes
    sql: ${temp_offset} ;;
  }
}
