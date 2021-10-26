# The name of this view in Looker is "Otau Configurations"
view: otau_configurations {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."OTAU_CONFIGURATIONS"
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
  # This dimension will be called "Default" in Explore.

  dimension: default {
    type: string
    sql: ${TABLE}."default" ;;
  }

  dimension: fw_type {
    type: string
    sql: ${TABLE}."FW_TYPE" ;;
  }

  dimension: hw_rev {
    type: number
    sql: ${TABLE}."HW_REV" ;;
  }

  dimension: max {
    type: string
    sql: ${TABLE}."MAX" ;;
  }

  dimension: min {
    type: string
    sql: ${TABLE}."MIN" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: update_percentage {
    type: number
    sql: ${TABLE}."UPDATE_PERCENTAGE" ;;
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

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_hw_rev {
    type: sum
    hidden: yes
    sql: ${hw_rev} ;;
  }

  measure: average_hw_rev {
    type: average
    hidden: yes
    sql: ${hw_rev} ;;
  }

  measure: total_update_percentage {
    type: sum
    hidden: yes
    sql: ${update_percentage} ;;
  }

  measure: average_update_percentage {
    type: average
    hidden: yes
    sql: ${update_percentage} ;;
  }
}
