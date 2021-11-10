# The name of this view in Looker is "Systems All"
view: systems_all {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."SYSTEMS_ALL"
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
  # This dimension will be called "Administrative Area" in Explore.

  dimension: administrative_area {
    type: string
    sql: ${TABLE}."ADMINISTRATIVE_AREA" ;;
  }


  dimension: us_states {
    type: string
    sql: ${TABLE}."ADMINISTRATIVE_AREA" ;;
    suggestions: ["Alabama", "Alaska", "Arizona", "Arkansas", "California","Colorado","Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
                  "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska",
                  "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
                  "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
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

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."DELETED_BY" ;;
  }

  dimension: emergency_number {
    type: string
    sql: ${TABLE}."EMERGENCY_NUMBER" ;;
  }

  dimension: fire_number {
    type: string
    sql: ${TABLE}."FIRE_NUMBER" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: locality {
    type: string
    sql: ${TABLE}."LOCALITY" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }


  dimension: lat_long {
    type: location
    sql_latitude:  ${latitude}::NUMBER(11,5) ;;
    sql_longitude: ${longitude}::NUMBER(11,5);;
  }

  dimension: membership_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."MEMBERSHIP_ID" ;;
  }

  dimension: mode {
    type: number
    sql: ${TABLE}."MODE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension_group: night_time_end {
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
    sql: ${TABLE}."NIGHT_TIME_END" ;;
  }

  dimension_group: night_time_start {
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
    sql: ${TABLE}."NIGHT_TIME_START" ;;
  }

  dimension: police_number {
    type: string
    sql: ${TABLE}."POLICE_NUMBER" ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}."POSTAL_CODE" ;;
  }

  dimension: timezone_id {
    type: string
    sql: ${TABLE}."TIMEZONE_ID" ;;
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
    drill_fields: [id, name, memberships.id]
  }

  measure: systems_count{
    type:  count_distinct
    sql: ${TABLE}.UUID ;;
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: total_latitude {
    type: sum
    hidden: yes
    sql: ${latitude} ;;
  }

  measure: average_latitude {
    type: average
    hidden: yes
    sql: ${latitude} ;;
  }

  measure: total_longitude {
    type: sum
    hidden: yes
    sql: ${longitude} ;;
  }

  measure: average_longitude {
    type: average
    hidden: yes
    sql: ${longitude} ;;
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
