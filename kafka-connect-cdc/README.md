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

    docker exec  mssql-crm /opt/mssql-tools/bin/sqlcmd -U sa -P MSQLserver10! -Q "select * From customers" -d crm -Y 15

The output should be:

```
id          name            surname         address         zip_code   city            country         nickname
----------- --------------- --------------- --------------- ---------- --------------- --------------- ---------------
          1 Jack            Turner          South Boulevard 37219      Indianapolis    New York        j.turner
          2 Maria           Reyes           Highland Drive  66603      Los Angeles     Texas           m_reyes
          3 Larry           Thomas          College Avenue  21401      Nashville       Georgia         larry.thomas
          4 Ashley          Edwards         Division Street 59623      San Jose        Missouri        aedwards
          5 Katherine       Scott           Front Street 96 57501      Milwaukee       Michigan        katherine.s
          6 Thomas          Hernandez       Meadowbrook Lan 39205      Cleveland       Ohio            thomas-h
          7 Theresa         Foster          Cypress Street  19901      San Francisco   West Virginia   theresa-foster
          8 Patricia        Davis           Main Road 0     29217      Kansas City     Oregon          patriciadavis
          9 Debra           Wilson          Cherry Lane 4   70802      Miami           Nevada          debra_w         
```

## Query Postgress

    docker exec pg-products psql -U postgresuser -d central_store -c 'SELECT  * FROM products limit 10'


The output should be:

```
     id |            name            |     brand     | price
    ----+----------------------------+---------------+-------
      1 | Macaroons - Two Bite Choc  | Zoomcast      |    41
      2 | Broom And Brush Rack Black | Jabberstorm   |    34
      3 | Ranchero - Primerba, Paste | Jabbersphere  |    53
      4 | Jack Daniels               | Twinte        |    69
      5 | Straws - Cocktale          | Rhycero       |    19
      6 | Nut - Cashews, Whole, Raw  | Thoughtworks  |    31
      7 | Sprouts Dikon              | Thoughtsphere |    33
      8 | Mountain Dew               | Browseblab    |    67
      9 | Miso - Soy Bean Paste      | Buzzbean      |    78
     10 | Beef - Bresaola            | Realcube      |    73
    (10 rows)
```

## Instantiate SQL Server connector

Run this command:

```
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
            "transforms": "unwrap",
            "table.include.list": "dbo.Customers,dbo.Orders",
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
    Date: Tue, 28 Nov 2023 14:18:35 GMT
    Location: http://localhost:8083/connectors/mssqlcrmcdc
    Content-Type: application/json
    Content-Length: 929
    Server: Jetty(9.4.51.v20230217)

    {"name":"mssqlcrmcdc","config":{"connector.class":"io.debezium.connector.sqlserver.SqlServerConnector","tasks.max":"1","initial.database":"crm","database.names":"crm","database.user":"sa","database.password":"MSQLserver10!","server.name":"sensor","database.hostname":"mssql-crm","server.port":"1433","topic.prefix":"mssql","name":"mssqlcrmcdc","transforms":"unwrap","table.include.list":"dbo.Customers,dbo.Orders","database.trustServerCertificate":"true","include.schema.changes":"false","transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState","key.converter":"org.apache.kafka.connect.json.JsonConverter","key.converter.schemas.enable":"false","value.converter":"org.apache.kafka.connect.json.JsonConverter","value.converter.schemas.enable":"false","schema.history.internal.kafka.topic":"history_internal_topic","schema.history.internal.kafka.bootstrap.servers":"broker:9092"},"tasks":[],"type":"source"}
```

Check the congiruation:

    curl -X GET -H  "Content-Type:application/json" http://localhost:8083/connectors/mssqlcrmcdc/config|jq

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

Check that the initial events arrived:

    docker exec -it schema-registry /usr/bin/kafka-avro-console-consumer --topic mssql.crm.dbo.Customers  --bootstrap-server broker:9092 --property print.key=true --property key.deserializer=org.apache.kafka.common.serialization.IntegerDeserializer --from-beginning

Now let's insert some orders:

    docker exec -i jr-cli jr run -n 10 -l insert_orders|xargs -I{} docker exec  mssql-crm /opt/mssql-tools/bin/sqlcmd -U sa -P MSQLserver10! -Q "{}" -d crm
    

## Instantiate Postgress connector



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


# Ksql setup
    docker exec -it ksqldb-cli ksql http://ksqldb-server:8088 
    
    SET 'auto.offset.reset' = 'earliest';

## Create the table and stream from sqlserver

We create a Table from customers:

    CREATE TABLE customers (id INT PRIMARY KEY, name string, surname string, address string,zip_code string,city string, country string, nickname string ) WITH (KAFKA_TOPIC = 'mssql.crm.dbo.Customers', VALUE_FORMAT='AVRO', KEY_FORMAT='KAFKA');    

Test if the table containes data:

    SELECT * FROM customers EMIT CHANGES;

We create the stream orders

   CREATE STREAM  orders (id INT KEY, itemid int, quantity int, customerid int ) WITH (kafka_topic='mssql.crm.dbo.Orders', value_format='AVRO', KEY_FORMAT='KAFKA');

Test the stream:

    SELECT * FROM  ORDERS EMIT CHANGES;

Create the Customers - Orders join stream

    CREATE stream CUSTOMERS_ORDERS as
        SELECT orders.id AS orderid, nickname, name, surname, quantity, customerid
            FROM orders
            LEFT JOIN customers ON orders.customerid = customers.id;


   SELECT * FROM  CUSTOMERS_ORDERS EMIT CHANGES;


## Create the table and stream from Postgress

We create a Table from products:

    CREATE TABLE products (id INT PRIMARY KEY, name string, brand string, price INT) WITH (KAFKA_TOPIC = 'pg.public.products', VALUE_FORMAT='AVRO', KEY_FORMAT='KAFKA');    

Test if the table containes data:

    SELECT * FROM products EMIT CHANGES;

## Join the data from SQL server and Postgress

Create the stream:

    CREATE stream CUSTOMERS_ORDERS_COMPLETE as
        SELECT orderid, nickname, CUSTOMERS_ORDERS.name as name, surname, quantity, customerid, products.name as productname, brand, price
            FROM CUSTOMERS_ORDERS
            LEFT JOIN products ON products.id = CUSTOMERS_ORDERS.orderid;

Check the events:

    SELECT * FROM CUSTOMERS_ORDERS_COMPLETE EMIT CHANGES;

# Now let's keep generating orders

    docker exec -i jr-cli jr run -f 1000ms -l insert_orders|xargs -I{} docker exec  mssql-crm /opt/mssql-tools/bin/sqlcmd -U sa -P MSQLserver10! -Q "{}" -d crm

Check ksql output Topic:

    [TBD]


    docker exec -i mongodb mongosh --eval 'db.orders.find();' ordersdb --username root --password rootpassword

    mongosh --eval 'db.orders.find();' ordersdb --username root --password rootpassword --host mongodb --port 27017