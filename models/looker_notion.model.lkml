# Define the database connection to be used for this model.
connection: "snowflake_poc"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: looker_notion_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_notion_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Looker Notion"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: sensor_messages {
  label: "Sensor Messages"
  view_label: "Sensor Messages"

  join: bridges_all {
    view_label: "Bridges"
    relationship: many_to_one
    sql_on: ${sensor_messages.bridge_hardware_id} = ${bridges_all.hardware_id} ;;
  }
  join: systems_all {
    view_label: "Systems"
    relationship: one_to_many
    sql_on: ${bridges_all.system_id} = ${systems_all.id} ;;
  }
  join: system_users_all  {
    view_label: "System Users"
    relationship: one_to_many
    sql_on: ${systems_all.uuid} = ${system_users_all.system_id} ;;
  }
  join: users_all  {
    view_label: "Users"
    relationship: one_to_many
    sql_on: ${system_users_all.user_id} = ${users_all.uuid} ;;
  }
}

explore: sensors_all {}
explore: users_all {}
explore: system_users_all {}
explore: systems_all {}
