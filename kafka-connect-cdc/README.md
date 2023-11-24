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
