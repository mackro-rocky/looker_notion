# The name of this view in Looker is "Oauth Applications"
view: oauth_applications {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."OAUTH_APPLICATIONS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Confidential" in Explore.

  dimension: confidential {
    type: yesno
    sql: ${TABLE}."CONFIDENTIAL" ;;
  }

  dimension: cors_domain {
    type: string
    sql: ${TABLE}."CORS_DOMAIN" ;;
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

  dimension: external_url {
    type: string
    sql: ${TABLE}."EXTERNAL_URL" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: owner_id {
    type: number
    sql: ${TABLE}."OWNER_ID" ;;
  }

  dimension: owner_type {
    type: string
    sql: ${TABLE}."OWNER_TYPE" ;;
  }

  dimension: redirect_uri {
    type: string
    sql: ${TABLE}."REDIRECT_URI" ;;
  }

  dimension: scopes {
    type: string
    sql: ${TABLE}."SCOPES" ;;
  }

  dimension: secret {
    type: string
    sql: ${TABLE}."SECRET" ;;
  }

  dimension: uid {
    type: string
    sql: ${TABLE}."UID" ;;
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
    drill_fields: [id, name]
  }
}

# These sum and average measures are hidden by default.
# If you want them to show up in your explore, remove hidden: yes.
