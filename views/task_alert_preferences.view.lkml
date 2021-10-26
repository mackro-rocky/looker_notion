# The name of this view in Looker is "Task Alert Preferences"
view: task_alert_preferences {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."TASK_ALERT_PREFERENCES"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Alert Type" in Explore.

  dimension: alert_type {
    type: number
    sql: ${TABLE}."ALERT_TYPE" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: enabled {
    type: yesno
    sql: ${TABLE}."ENABLED" ;;
  }

  dimension: listener_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."LISTENER_ID" ;;
  }

  dimension: system_user_id {
    type: string
    sql: ${TABLE}."SYSTEM_USER_ID" ;;
  }

  dimension: task_id {
    type: number
    sql: ${TABLE}."TASK_ID" ;;
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
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [id, listeners.id]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_alert_type {
    type: sum
    hidden: yes
    sql: ${alert_type} ;;
  }

  measure: average_alert_type {
    type: average
    hidden: yes
    sql: ${alert_type} ;;
  }
}
