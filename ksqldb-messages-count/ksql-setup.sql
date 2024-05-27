CREATE STREAM orders (order_id VARCHAR, ts VARCHAR) WITH (KAFKA_TOPIC ='orders', VALUE_FORMAT='JSON');

CREATE TABLE orders_statistics as
    SELECT 'orders' as O  , TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss','Europe/London')
            AS DATE,
        COUNT(*) AS MSG_COUNT
    FROM orders
        WINDOW TUMBLING (SIZE 5 SECONDS)
    GROUP BY 'orders'
    EMIT FINAL;
