curl -i -X PUT -H  "Content-Type:application/json" \
    http://localhost:8083/connectors/pgproductscdc/config \
    -d '{
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "tasks.max": "1",
        "snapshot.mode": "always",
        "database.dbname": "central_store",
        "database.user": "postgresuser",
        "database.password": "postgrespw",            
        "database.hostname": "pg-products",
        "database.port": "5432",        
        "topic.prefix": "pg",
        "name": "pgproductscdc",                    
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