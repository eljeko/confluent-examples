# Start docker

This tutorial uses [jq](https://jqlang.github.io/jq/) to format some outputs of the Confluent Platform components

Star the docker clster with:

    ./start-cluster.sh

# Check the connect setup

Wait for cluster to start and then check if the plugins are correctly installed with this command:

    curl localhost:8083/connector-plugins|jq

Should output:

    [
    {
        "class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "type": "sink",
        "version": "10.7.4"
    },
    {
        "class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "type": "source",
        "version": "10.7.4"
    },
    {
        "class": "io.debezium.connector.postgresql.PostgresConnector",
        "type": "source",
        "version": "2.2.1.Final"
    },
    {
        "class": "io.debezium.connector.sqlserver.SqlServerConnector",
        "type": "source",
        "version": "2.2.1.Final"
    },
    {
        "class": "org.apache.kafka.connect.mirror.MirrorCheckpointConnector",
        "type": "source",
        "version": "7.5.0-ccs"
    },
    {
        "class": "org.apache.kafka.connect.mirror.MirrorHeartbeatConnector",
        "type": "source",
        "version": "7.5.0-ccs"
    },
    {
        "class": "org.apache.kafka.connect.mirror.MirrorSourceConnector",
        "type": "source",
        "version": "7.5.0-ccs"
    }
    ]


# Check the databases

Wait for database to start and init with the sql script provided in docker-compose.

## Query mssql

```docker exec  mssql-readings-source /opt/mssql-tools/bin/sqlcmd -U sa -P MSQLserver10! -Q "select * From sensors_readings" -d factory -Y 15```

The output should be:

```
id          sensor_id       sensor_ip       longitude       latitude        reading
----------- --------------- --------------- --------------- --------------- ---------------
          1 SRN-7171        185.188.156.122 115.038835      30.20003        91
          2 SRN-3111        137.231.8.149   113.078569      23.41698        61
          3 SRN-5161        150.161.233.244 34.0761476      45.0023182      51
          4 SRN-8151        168.210.225.70  120.992642      14.570684       51
          5 SRN-4131        217.220.49.217  111.809478      21.951497       11
          6 SRN-2111        159.243.148.244 122.8993        10.237          21             
```

## Instantiate SQL Server connector

Run this command:

```
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
```

You should get an output similar to this one:

```
    HTTP/1.1 201 Created
    Date: Fri, 24 Nov 2023 16:41:11 GMT
    Location: http://localhost:8083/connectors/mssqlsensorscdc
    Content-Type: application/json
    Content-Length: 945
    Server: Jetty(9.4.51.v20230217)

    {"name":"mssqlsensorscdc","config":{"connector.class":"io.debezium.connector.sqlserver.SqlServerConnector","tasks.max":"1","initial.database":"factory","database.names":"factory","database.user":"sa","database.password":"MSQLserver10!","server.name":"sensor","database.hostname":"mssql-readings-source","server.port":"1433","topic.prefix":"mssql","name":"mssqlsensorscdc","transforms":"unwrap","table.include.list":"dbo.sensors_readings","database.trustServerCertificate":"true","include.schema.changes":"false","transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState","key.converter":"org.apache.kafka.connect.json.JsonConverter","key.converter.schemas.enable":"false","value.converter":"org.apache.kafka.connect.json.JsonConverter","value.converter.schemas.enable":"false","schema.history.internal.kafka.topic":"history_internal_topic","schema.history.internal.kafka.bootstrap.servers":"broker:9092"},"tasks":[],"type":"source"}
```

Check the congiruation:

    curl -X GET -H  "Content-Type:application/json" http://localhost:8083/connectors/mssqlsensorscdc/config|jq

You should get:

```
    {
    "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "initial.database": "factory",
    "database.user": "sa",
    "database.names": "factory",
    "server.name": "sensor",
    "tasks.max": "1",
    "transforms": "unwrap",
    "schema.history.internal.kafka.bootstrap.servers": "broker:9092",
    "include.schema.changes": "false",
    "key.converter.schemas.enable": "false",
    "topic.prefix": "mssql",
    "schema.history.internal.kafka.topic": "history_internal_topic",
    "database.hostname": "mssql-readings-source",
    "database.password": "MSQLserver10!",
    "server.port": "1433",
    "name": "mssqlsensorscdc",
    "value.converter.schemas.enable": "false",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "table.include.list": "dbo.sensors_readings",
    "database.trustServerCertificate": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter"
    }
```

## Instantiate MongoDB connector

```
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
```

You should get an output similar to this one:

```
    HTTP/1.1 201 Created
    Date: Mon, 27 Nov 2023 15:24:58 GMT
    Location: http://localhost:8083/connectors/mongocdcsink
    Content-Type: application/json
    Content-Length: 468
    Server: Jetty(9.4.51.v20230217)

    {"name":"mongocdcsink","config":{"name":"mongocdcsink","connector.class":"com.mongodb.kafka.connect.MongoSinkConnector","topics":"mssql.factory.dbo.sensors_readings","connection.uri":"mongodb://root:rootpassword@mongodb","key.converter":"org.apache.kafka.connect.storage.StringConverter","value.converter":"org.apache.kafka.connect.json.JsonConverter","value.converter.schemas.enable":"false","database":"readings_db","collection":"readings"},"tasks":[],"type":"sink"}
```

Check the congiruation:

    curl -X GET -H  "Content-Type:application/json" http://localhost:8083/connectors/mongocdcsink/config|jq

You should get:

```
    {
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "database": "readings_db",
    "topics": "mssql.factory.dbo.sensors_readings",
    "name": "mongocdcsink",
    "connection.uri": "mongodb://root:rootpassword@mongodb",
    "value.converter.schemas.enable": "false",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "collection": "readings",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter"
    }
```