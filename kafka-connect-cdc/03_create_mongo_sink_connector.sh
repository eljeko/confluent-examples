curl -i -X PUT -H  "Content-Type:application/json" \
    http://localhost:8083/connectors/mongocdcsink/config \
    -d '{
        "name": "mongocdcsink",
        "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
        "topics": "CUSTOMERS_ORDERS_COMPLETE",
        "connection.uri": "mongodb://root:rootpassword@mongodb",
        "key.converter": "org.apache.kafka.connect.converters.IntegerConverter",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "value.converter.schemas.enable": "true",
        "value.converter.schema.registry.url": "http://schema-registry:8081",
        "database": "ordersdb",
        "collection": "orders"         
    }'