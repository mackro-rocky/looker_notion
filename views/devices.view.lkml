# The name of this view in Looker is "Devices"
view: devices {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."DEVICES"
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
  # This dimension will be called "App Version" in Explore.

  dimension: app_version {
    type: string
    sql: ${TABLE}."APP_VERSION" ;;
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

  dimension: endpoint {
    type: string
    sql: ${TABLE}."ENDPOINT" ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}."OS_VERSION" ;;
  }

  dimension: platform {
    type: number
    sql: ${TABLE}."PLATFORM" ;;
  }

  dimension: push_enabled {
    type: yesno
    sql: ${TABLE}."PUSH_ENABLED" ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}."TOKEN" ;;
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
    drill_fields: [id, session_tokens.count]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_platform {
    type: sum
    hidden: yes
    sql: ${platform} ;;
  }

  measure: average_platform {
    type: average
    hidden: yes
    sql: ${platform} ;;
  }
}
