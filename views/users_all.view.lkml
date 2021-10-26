# The name of this view in Looker is "Users All"
view: users_all {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."USERS_ALL"
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
  # This dimension will be called "Authentication Token" in Explore.

  dimension: authentication_token {
    type: string
    sql: ${TABLE}."AUTHENTICATION_TOKEN" ;;
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

  dimension_group: current_sign_in {
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
    sql: ${TABLE}."CURRENT_SIGN_IN_AT" ;;
  }

  dimension: current_sign_in_ip {
    type: string
    sql: ${TABLE}."CURRENT_SIGN_IN_IP" ;;
  }

  dimension_group: deleted {
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
    sql: CAST(${TABLE}."DELETED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."DELETED_BY" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: encrypted_password {
    type: string
    sql: ${TABLE}."ENCRYPTED_PASSWORD" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension_group: last_sign_in {
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
    sql: ${TABLE}."LAST_SIGN_IN_AT" ;;
  }

  dimension: last_sign_in_ip {
    type: string
    sql: ${TABLE}."LAST_SIGN_IN_IP" ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
  }

  dimension_group: remember_created {
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
    sql: ${TABLE}."REMEMBER_CREATED_AT" ;;
  }

  dimension_group: reset_password_sent {
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
    sql: ${TABLE}."RESET_PASSWORD_SENT_AT" ;;
  }

  dimension: reset_password_token {
    type: string
    sql: ${TABLE}."RESET_PASSWORD_TOKEN" ;;
  }

  dimension: role {
    type: number
    sql: ${TABLE}."ROLE" ;;
  }

  dimension: sign_in_count {
    type: number
    sql: ${TABLE}."SIGN_IN_COUNT" ;;
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

  dimension: uuid {
    type: string
    sql: ${TABLE}."UUID" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_role {
    type: sum
    hidden: yes
    sql: ${role} ;;
  }

  measure: average_role {
    type: average
    hidden: yes
    sql: ${role} ;;
  }

  measure: total_sign_in_count {
    type: sum
    hidden: yes
    sql: ${sign_in_count} ;;
  }

  measure: average_sign_in_count {
    type: average
    hidden: yes
    sql: ${sign_in_count} ;;
  }
}
