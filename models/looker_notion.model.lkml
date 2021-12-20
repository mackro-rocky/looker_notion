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
  join: hardware_bridges {
    view_label: "HW Bridges"
    relationship: many_to_one
    sql_on: ${bridges_all.hardware_id} = ${hardware_bridges.id} ;;
  }
  join: systems_all {
    view_label: "Systems"
    relationship: one_to_many
    sql_on: ${sensors_all.system_id} = ${systems_all.id} ;;
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
  join: sensors_all {
    view_label: "Sensors"
    relationship:many_to_one
    sql_on: ${sensors_all.hardware_id} = ${sensor_messages.hardware_id}    ;;
  }
  join: hardware_sensors {
    view_label: "Hardware Sensors"
    relationship: many_to_one
    sql_on: ${sensors_all.hardware_id} = ${hardware_sensors.id} ;;
  }
}




explore: systems_all {
  view_label: "Systems"
  label: "Systems"
  join: bridges_all {
    view_label: "Bridges"
    relationship: many_to_one
    sql_on: ${bridges_all.system_id} = ${systems_all.id}  ;;
  }
  join: hardware_bridges {
    view_label: "HW Bridges"
    relationship: many_to_one
    sql_on: ${bridges_all.hardware_id} = ${hardware_bridges.id} ;;
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
  join: consents_all {
    view_label: "Consents"
    relationship: many_to_one
    sql_on: ${consents_all.system_id} = ${systems_all.uuid}  ;;
  }
  join: groups {
    view_label: "Groups"
    relationship: many_to_one
    sql_on: ${consents_all.group_id} = ${groups.id}  ;;
  }
  join: sensors_all {
    view_label: "Sensors"
    relationship: many_to_one
    sql_on: ${sensors_all.system_id} = ${systems_all.id}  ;;

  }
  join: hardware_sensors {
    view_label: "Hardware Sensors"
    relationship: many_to_one
    sql_on: ${sensors_all.hardware_id} = ${hardware_sensors.id} ;;

  }
  join: integrations_all {
    view_label: "Integrations"
    relationship: many_to_one
    sql_on: ${integrations_all.system_id} = ${systems_all.uuid}  ;;
  }
}


explore: model_states_sensor {
  label: "Model States"
  view_label: "Model States"


  join: listeners_sensor_all {
    view_label: "Listener Sensors"
    relationship: one_to_many
    sql_on:  ${model_states_sensor.listener_id} = ${listeners_sensor_all.id} ;;
  }

  join: sensors_all {
    view_label: "Sensors"
    relationship: one_to_many
    sql_on:  ${sensors_all.uuid} = ${listeners_sensor_all.sensor_id} ;;
  }

  join: systems_all {
    view_label: "Systems"
    relationship: one_to_many
    sql_on:  ${systems_all.id} = ${sensors_all.system_id} ;;
  }

  join: system_users_all {
    view_label: "System Users"
    relationship: one_to_many
    sql_on:  ${system_users_all.system_id} = ${systems_all.uuid} ;;
  }

  join: users_all {
    view_label: "Users"
    relationship: one_to_many
    sql_on:  ${users_all.uuid} = ${system_users_all.user_id} ;;
  }
}

explore:  latest_model_state {
  label: "Latest Model State"
  view_label: "Latest Model State"

  join: listeners_sensor_all {
    view_label: "Listener Sensors"
    relationship: one_to_one
    sql_on:  ${latest_model_state.listener_id} = ${listeners_sensor_all.id} ;;
  }

  join: sensors_all {
    view_label: "Ephemeral Sensors"
    relationship: one_to_many
    sql_on:  ${sensors_all.uuid} = ${listeners_sensor_all.sensor_id} ;;
  }

  # join: task_types {
  #   view_label: "Task Types"
  #   relationship: one_to_many
  #   sql_on:  ${task_type.id} = ${listeners_sensor_all.task_type_id} ;;
  # }
}

explore: task_counts {
  label: "Task Counts"
  view_label: "Task Counts"
}

explore: hardware_sensors {
  label: "Sensor Hardware"
  view_label: "Sensor Hardware"

  join: sensors_all {
    view_label: "Ephemeral Sensors"
    relationship: one_to_many
    sql_on: ${hardware_sensors.id} = ${sensors_all.hardware_id} ;;
  }

  join: current_sensors {
    view_label: "Current Sensors"
    relationship: one_to_one
    sql_on: ${hardware_sensors.id} = ${current_sensors.hardware_id} ;;
  }

  join: listeners_sensor_all {
    view_label: "Sensor Listeners"
    relationship: one_to_many
    sql_on: ${sensors_all.uuid} = ${listeners_sensor_all.sensor_id} ;;
  }
}

explore: sensor_status {
  label: "Sensor Status"
  view_label: "Sensor Status"
}

explore: system_status {
  label: "System Status"
  view_label: "System Status"
}


explore: system_stats {}
### Commented out for now
#  explore: sensors_all {}
#  explore: users_all {}
#  explore: system_users_all {}
