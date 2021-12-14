# The name of this view in Looker is "Task Counts"
view: task_counts {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."TASK_COUNTS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Model Version" in Explore.

  dimension: model_version {
    type: string
    sql: ${TABLE}."MODEL_VERSION" ;;
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

  dimension: task_name {
    type: string
    sql: ${TABLE}."TASK_NAME" ;;
  }

  dimension: version_count {
    type: number
    sql: ${TABLE}."VERSION_COUNT" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_version_count {
    type: sum
    sql: ${version_count} ;;
  }

  measure: average_version_count {
    type: average
    sql: ${version_count} ;;
  }

  measure: count {
    type: count
    drill_fields: [task_name]
  }
}
