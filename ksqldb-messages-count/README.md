# start docker-compose

    ./start-cluster.sh

# Create the topic orders

    docker exec -i broker kafka-topics --bootstrap-server broker:9092 --topic orders --create --partitions 3 --replication-factor 1

# Generate some data with [jr](https://jrnd.io/)

    docker exec -i jr-cli jr run -l -n1 -f 1000ms shoe_order|docker exec -i broker kafka-console-producer --bootstrap-server broker:9092 --topic orders

You can change the values for -n1 -f 1000ms

    -n int              Number of elements to create for each pass (default 1)
    -f duration         how much time to wait for next generation pass (default -1ns)

# Setup Ksql

Create the stream on the topic:

    CREATE STREAM orders (order_id VARCHAR, ts VARCHAR) WITH (KAFKA_TOPIC ='orders', VALUE_FORMAT='JSON');

Query the stram on a WINDOW size:

    SELECT TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss','Europe/London')
        AS DATE,
        COUNT(*) AS MSG_COUNT
    FROM orders
        WINDOW TUMBLING (SIZE 5 SECONDS)
    GROUP BY 1
    EMIT FINAL;

You can create Create a materialized view

    CREATE TABLE orders_statistics as
    SELECT 'orders' as O  , TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss','Europe/London')
            AS DATE,
        COUNT(*) AS MSG_COUNT
    FROM orders
        WINDOW TUMBLING (SIZE 5 SECONDS)
    GROUP BY 'orders'
    EMIT FINAL;

# Fast setup

You can run the command:

    ./setup-demo.sh

This will prepare everything for you.

Query the Table from CLI (remember to start first the data generator with jr):
    
    docker exec -it ksqldb-cli ksql http://ksqldb-server:8088 -e "SELECT DATE, MSG_COUNT  FROM orders_statistics EMIT CHANGES;"

Consumer the Table topic with an application:

    docker exec -i broker  kafka-console-consumer --bootstrap-server  broker:9092 --topic  ORDERS_STATISTICS
