curl -i -X PUT -H  "Content-Type:application/json" \
    http://localhost:8083/connectors/mongocdcsink/config \
    -d '{
        "name": "mongocdcsink",
        "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
        "topics": "mssql.factory.dbo.sensors_readings",
        "connection.uri": "mongodb://root:rootpassword@mongodb",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": "false",
        "database": "readings_db",
        "collection": "readings"         
    }'