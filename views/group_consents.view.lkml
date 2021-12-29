

 view: group_consents {
#   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: select system_id,
                 max(group_id) as group_id
          from  "PC_STITCH_DB"."PRODUCTION_APPLICATION"."CONSENTS_ALL"
          group by system_id ;;
  }
  dimension: system_id {
    type: string
    sql: ${TABLE}.system_id ;;
  }
  dimension: group_id {
    type: string
    sql: ${TABLE}.group_id ;;
  }
}
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
