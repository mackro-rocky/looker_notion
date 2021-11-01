# The name of this view in Looker is "Bridges All"
view: bridges_all {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."BRIDGES_ALL"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
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
    sql: ${TABLE}."CREATED_AT" ;;
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

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Deleted By" in Explore.

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."DELETED_BY" ;;
  }

  dimension: hardware_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."HARDWARE_ID" ;;
  }

  dimension: hardware_id_old {
    type: string
    sql: ${TABLE}."HARDWARE_ID_OLD" ;;
  }

  dimension: hardware_revision {
    type: number
    sql: ${TABLE}."HARDWARE_REVISION" ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}."METADATA" ;;
  }

  dimension_group: missing {
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
    sql: ${TABLE}."MISSING_AT" ;;
  }

  dimension: mode {
    type: number
    sql: ${TABLE}."MODE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: system_id {
    type: number
    sql: ${TABLE}."SYSTEM_ID" ;;
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
    drill_fields: [id, name, hardware.id]
  }

  measure: bridges_count {
    type: count_distinct
    sql: ${TABLE}.ID ;;
  }
  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_hardware_revision {
    type: sum
    hidden: yes
    sql: ${hardware_revision} ;;
  }

  measure: average_hardware_revision {
    type: average
    hidden: yes
    sql: ${hardware_revision} ;;
  }

  measure: total_mode {
    type: sum
    hidden: yes
    sql: ${mode} ;;
  }

  measure: average_mode {
    type: average
    hidden: yes
    sql: ${mode} ;;
  }
}
