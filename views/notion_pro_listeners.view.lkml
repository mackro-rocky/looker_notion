
view: notion_pro_listeners {
  derived_table: {
    sql: SELECT
        systems_all."ID"  AS "system_id",
        systems_all."UUID"  AS "system_uuid",
        sensors_all."UUID"  AS "sensor_uuid",
        integrations_all."TYPE"  AS "integration_type",
        hardware_sensors."SERIAL_NUMBER"  AS "sensor_serial_number",
        task_types."NAME"  AS "task_name",
        listeners_sensor_all."ID"  AS "listeners_sensor_id",
        listener_inputs_all."ID"  AS "listener_inputs_id",
        listeners_integration_all."ID"  AS "listeners_integration_id",
            (TO_CHAR(TO_DATE(CAST(integrations_all."CONNECTED_AT" AS TIMESTAMP_NTZ) ), 'YYYY-MM-DD')) AS "connected_date"
    FROM "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SYSTEMS_ALL"
         AS systems_all
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."INTEGRATIONS_ALL"
         AS integrations_all ON (systems_all."UUID") = (integrations_all."SYSTEM_ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."LISTENERS_INTEGRATION_ALL"
         AS listeners_integration_all ON (integrations_all."ID") = (listeners_integration_all."INTEGRATION_ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."SENSORS_ALL"
         AS sensors_all ON (sensors_all."SYSTEM_ID") = (systems_all."ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."HARDWARE_SENSORS"
         AS hardware_sensors ON (sensors_all."HARDWARE_ID") = (hardware_sensors."ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."LISTENERS_SENSOR_ALL"
         AS listeners_sensor_all ON (sensors_all."UUID") = (listeners_sensor_all."SENSOR_ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."TASK_TYPES"
         AS task_types ON (listeners_sensor_all."TASK_TYPE_ID") = (task_types."ID")
    LEFT JOIN "PC_STITCH_DB"."PRODUCTION_APPLICATION"."LISTENER_INPUTS_ALL"
         AS listener_inputs_all ON (listener_inputs_all."SOURCE_ID") = (listeners_sensor_all."ID")
          AND (listener_inputs_all."TARGET_ID") = (listeners_integration_all."ID")
    WHERE CAST(systems_all."DELETED_AT" AS TIMESTAMP_NTZ) IS NULL
      AND CAST(integrations_all."CONNECTED_AT" AS TIMESTAMP_NTZ) IS NOT NULL
      AND CAST(integrations_all."DELETED_AT" AS TIMESTAMP_NTZ) IS NULL
      AND integrations_all."TYPE" = 'Integrations::NotionPRO'
      AND CAST(listeners_integration_all."DELETED_AT" AS TIMESTAMP_NTZ)  IS NULL
      AND listeners_integration_all."TASK_TYPE_ID"  = 34
      AND CAST(sensors_all."DELETED_AT" AS TIMESTAMP_NTZ) IS NULL
      AND COALESCE(DATEDIFF(hour, CAST(sensors_all."MISSING_AT" AS TIMESTAMP_NTZ), CURRENT_TIMESTAMP), 0) < 24
      AND CAST(listeners_sensor_all."DELETED_AT" AS TIMESTAMP_NTZ) IS NULL
      AND (task_types."NAME"  <> 'temperature' OR task_types."NAME"  IS NULL)
      AND (task_types."PRIORITY" ) < 40
      AND CAST(listener_inputs_all."DELETED_AT" AS TIMESTAMP_NTZ) IS NULL
      AND listener_inputs_all."ID"  IS NOT NULL
    GROUP BY
        (TO_DATE(CAST(integrations_all."CONNECTED_AT" AS TIMESTAMP_NTZ) )),
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
    ORDER BY
        1
     ;;
  }

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: system_id {
    type: number
    sql: ${TABLE}."system_id" ;;
  }

  dimension: system_uuid {
    type: string
    sql: ${TABLE}."system_uuid" ;;
  }

  dimension: sensor_uuid {
    type: string
    sql: ${TABLE}."sensor_uuid" ;;
  }

  dimension: integration_type {
    type: string
    sql: ${TABLE}."integration_type" ;;
  }

  dimension: sensor_serial_number {
    type: string
    sql: ${TABLE}."sensor_serial_number" ;;
  }

  dimension: task_name {
    type: string
    sql: ${TABLE}."task_name" ;;
  }

  dimension: listeners_sensor_id {
    type: string
    sql: ${TABLE}."listeners_sensor_id" ;;
  }

  dimension: listener_inputs_id {
    type: string
    sql: ${TABLE}."listener_inputs_id" ;;
  }

  dimension: listeners_integration_id {
    type: string
    sql: ${TABLE}."listeners_integration_id" ;;
  }

  dimension: connected_date {
    type: string
    sql: ${TABLE}."connected_date" ;;
  }

  set: detail {
    fields: [
      system_id,
      system_uuid,
      sensor_uuid,
      integration_type,
      sensor_serial_number,
      task_name,
      listeners_sensor_id,
      listener_inputs_id,
      listeners_integration_id,
      connected_date
    ]
  }
}
