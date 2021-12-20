# The name of this view in Looker is "System Status"
view: system_status {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SYSTEM_STATUS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Max Hw Revision" in Explore.

  dimension: max_hw_revision {
    type: number
    sql: ${TABLE}."MAX_HW_REVISION" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_max_hw_revision {
    type: sum
    sql: ${max_hw_revision} ;;
  }

  measure: average_max_hw_revision {
    type: average
    sql: ${max_hw_revision} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: system_count {
    type: number
    sql: ${TABLE}."SYSTEM_COUNT" ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: query_timestamp {
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
    sql: ${TABLE}."QUERY_TIMESTAMP" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
