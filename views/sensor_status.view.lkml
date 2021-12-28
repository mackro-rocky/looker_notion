# The name of this view in Looker is "Sensor Status"
view: sensor_status {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SENSOR_STATUS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Hw Revision" in Explore.

  dimension: hw_revision {
    type: number
    sql: ${TABLE}."HW_REVISION" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_hw_revision {
    type: sum
    sql: ${hw_revision} ;;
  }

  measure: average_hw_revision {
    type: average
    sql: ${hw_revision} ;;
  }

  dimension: live_state {
    type: string
    sql: ${TABLE}."LIVE_STATE" ;;
  }

  dimension: num_sensors {
    type: number
    sql: ${TABLE}."NUM_SENSORS" ;;
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
