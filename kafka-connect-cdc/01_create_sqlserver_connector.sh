    curl -i -X PUT -H  "Content-Type:application/json" \
        http://localhost:8083/connectors/mssqlcrmcdc/config \
        -d '{
            "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
            "tasks.max": "1",
            "initial.database": "crm",
            "database.names": "crm",
            "database.user": "sa",
            "database.password": "MSQLserver10!",
            "server.name": "sensor",
            "database.hostname": "mssql-crm",
            "server.port": "1433",        
            "topic.prefix": "mssql",
            "name": "mssqlcrmcdc",            
            "table.include.list": "dbo.Customers,dbo.Orders",
            "database.trustServerCertificate": "true",
            "include.schema.changes": "false",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "transforms": "extractKey, unwrap",
            "transforms.extractKey.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
            "transforms.extractKey.field": "id",
            "key.converter": "org.apache.kafka.connect.converters.IntegerConverter",
            "key.converter.schemas.enable": "false",    
            "value.converter": "io.confluent.connect.avro.AvroConverter",
            "value.converter.schemas.enable": "true",
            "value.converter.schema.registry.url": "http://schema-registry:8081",
            "schema.history.internal.kafka.topic": "history_internal_topic",
            "schema.history.internal.kafka.bootstrap.servers": "broker:9092"
        }'