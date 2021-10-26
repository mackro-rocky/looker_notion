# The name of this view in Looker is "User Preferences"
view: user_preferences {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."USER_PREFERENCES"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Battery Alerts Enabled" in Explore.

  dimension: battery_alerts_enabled {
    type: yesno
    sql: ${TABLE}."BATTERY_ALERTS_ENABLED" ;;
  }

  dimension: celsius_enabled {
    type: yesno
    sql: ${TABLE}."CELSIUS_ENABLED" ;;
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

  dimension: disconnect_alerts_enabled {
    type: yesno
    sql: ${TABLE}."DISCONNECT_ALERTS_ENABLED" ;;
  }

  dimension: home_away_alerts_enabled {
    type: yesno
    sql: ${TABLE}."HOME_AWAY_ALERTS_ENABLED" ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}."LOCALE" ;;
  }

  dimension: military_time_enabled {
    type: yesno
    sql: ${TABLE}."MILITARY_TIME_ENABLED" ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: []
  }
}

# These sum and average measures are hidden by default.
# If you want them to show up in your explore, remove hidden: yes.
