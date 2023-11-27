curl -i -X PUT -H  "Content-Type:application/json" \
        http://localhost:8083/connectors/mssqlsensorscdc/config \
        -d '{
            "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
            "tasks.max": "1",
            "initial.database": "factory",
            "database.names": "factory",
            "database.user": "sa",
            "database.password": "MSQLserver10!",
            "server.name": "sensor",
            "database.hostname": "mssql-readings-source",
            "server.port": "1433",        
            "topic.prefix": "mssql",
            "name": "mssqlsensorscdc",
            "transforms": "unwrap",
            "table.include.list": "dbo.sensors_readings",
            "database.trustServerCertificate": "true",
            "include.schema.changes": "false",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "key.converter": "org.apache.kafka.connect.json.JsonConverter",
            "key.converter.schemas.enable": "false",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "value.converter.schemas.enable": "false",
            "schema.history.internal.kafka.topic": "history_internal_topic",
            "schema.history.internal.kafka.bootstrap.servers": "broker:9092"
        }'