# Start Confluent Platform

Run

    docker-compose up

## Create streams and tables interactively using the CLI

To begin developing interactively, open up the ksqlDB CLI:

    docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
    
We are going to start out by creating a ksqlDB table and a ksqlDB stream. Our table will hold reference data about repair centers. The stream will contain insurance related events.

Let’s start with the repair shop table. We want to be able to direct customers to their closest repair center. To accomplish that, we need to load the location of the repair shops into another ksqlDB table. Create the ksqlDB repair_center_tab table.

    CREATE TABLE repair_center_tab (repair_state VARCHAR PRIMARY KEY, long DOUBLE, lat DOUBLE)
       WITH (kafka_topic='repair_center', value_format='avro', partitions=1);

Insert repair shop data into the repair_center_tab table.


    INSERT INTO repair_center_tab (repair_state, long, lat) VALUES ('IT', 41.9028, 12.4964);
    
    INSERT INTO repair_center_tab (repair_state, long, lat) VALUES ('NSW', 151.1169, -33.863);

    INSERT INTO repair_center_tab (repair_state, long, lat) VALUES ('VIC', 145.1549, -37.9389);

Lastly, imagine we have a stream of insurance claim events for people who have lost their insured mobile phone. We know the customer name, phone model, and the state, long and lat where the loss of the mobile phone occurred. The following ksqlDB statement will create a new topic phone_event_raw and a stream insurance_event_stream:

    CREATE STREAM insurance_event_stream (customer_name VARCHAR, phone_model VARCHAR, event VARCHAR, state VARCHAR, long DOUBLE, lat DOUBLE)
       WITH (kafka_topic='phone_event_raw', value_format='avro', partitions=1);

Now populate the stream with sample events:

    INSERT INTO insurance_event_stream (customer_name, phone_model, event, state, long, lat)
            VALUES ('Lindsey', 'iPhone 11 Pro', 'dropped', 'NSW', 151.25664, -33.85995);

    INSERT INTO insurance_event_stream (customer_name, phone_model, event, state, long, lat)
            VALUES ('Debbie', 'Samsung Note 20', 'water', 'NSW', 151.24504, -33.89640);

## Calculate lat-long distances

Before we move forward, we need to set the auto.offset.reset property to ensure that you’re reading from the beginning of the stream:
    
    SET 'auto.offset.reset' = 'earliest';

In order to calculate how far away the repair center is from the insurance event, we will need to create a stream that joins the insurance events with our repair center reference data. or this use case, let’s assume there is only one repair center in each STATE and the repair center in an event’s STATE is the closest repair center.

    CREATE STREAM insurance_event_with_repair_info AS
    SELECT * FROM insurance_event_stream iev
    INNER JOIN repair_center_tab rct ON iev.state = rct.repair_state;

Let’s query our newly created stream, insurance_event_with_repair_info, to view a the insurance event with location information with the ksqlDB statement below:

    SELECT IEV_CUSTOMER_NAME, IEV_LONG, IEV_LAT, RCT_LONG, RCT_LAT
    FROM insurance_event_with_repair_info
    EMIT CHANGES
    LIMIT 2;

The query will produce something like this:

    +--------------------+--------------------+--------------------+--------------------+--------------------+
    |IEV_CUSTOMER_NAME   |IEV_LONG            |IEV_LAT             |RCT_LONG            |RCT_LAT             |
    +--------------------+--------------------+--------------------+--------------------+--------------------+
    |Lindsey             |151.25664           |-33.85995           |151.1169            |-33.863             |
    |Debbie              |151.24504           |-33.8964            |151.1169            |-33.863             |
    Limit Reached
    Query terminated

The last thing for us to do is calculate the distance between the repair center lat-long and insurance event lat-long. We can do that with the geo_distance ksqlDB function.

    SELECT iev_customer_name, iev_state,
        geo_distance(iev_lat, iev_long, rct_lat, rct_long, 'km') AS dist_to_repairer_km
    FROM insurance_event_with_repair_info
    EMIT CHANGES
    LIMIT 2;

geo_distance calculates the great-circle distance between two lat-long points, both specified in decimal degrees. An optional final parameter specifies km (the default) or miles.

The output should resemble:

    +--------------------+--------------------+--------------------+
    |IEV_CUSTOMER_NAME   |IEV_STATE           |DIST_TO_REPAIRER_KM |
    +--------------------+--------------------+--------------------+
    |Lindsey             |NSW                 |12.907325150628191  |
    |Debbie              |NSW                 |12.398568134716221  |
    Limit Reached
    Query terminated

Now that our query reporting the distance to the nearest repair center is working, let’s update it to create a continuous query.

    CREATE STREAM insurance_event_dist AS
    SELECT iev_customer_name, iev_state,
                geo_distance(iev_lat, iev_long, rct_lat, rct_long, 'km') AS dist_to_repairer_km
    FROM insurance_event_with_repair_info;

## Write your statements to a file

You can create all the statments and setup the ksql scenario running the script ```setup.sh``` that will execute the sql script: ```src/statements.sql``` in the ksqldb-cli container

# Test it
## Use the test data

Check the file ```input.json```

Check the file ```output.json```

## Invoke the tests

Prepare the kslqdb-cli container with tests files:

    docker cp test/input.json ksqldb-cli:/home/appuser/input.json
    docker cp test/output.json ksqldb-cli:/home/appuser/output.json
    docker cp src/statements.sql ksqldb-cli:/home/appuser/statements.sql


Lastly, invoke the tests using the test runner and the statements file that you created earlier:

    docker exec ksqldb-cli ksql-test-runner -i /home/appuser/input.json -s /home/appuser/statements.sql -o /home/appuser/output.json

Which should pass:

	 >>> Test passed!

# Let's play with data

Run the ```setup.sh``` script to create all the statements.

List the topics:

    kafka-topics --bootstrap-server=localhost:9092 --list

Should contain

* default_ksql_processing_log
* orders
* phone_event_raw
* repair_center

Check if the Schema Registry contains all the schemas created by the ksql statements

    curl http://localhost:8081/schemas |jq

Get the id of the schema:

    export SCHEMA_ID=$(curl -s http://localhost:8081/schemas |jq '.[]| select(.subject == "phone_event_raw-value").id')

Try send a message, note that the fields use the spefication type for the value, otherwise you can get a ```Caused by: org.apache.avro.AvroTypeException: Expected start-union. Got VALUE_STRING``` exception.

    {"CUSTOMER_NAME": {"string":"Lindsey"},"PHONE_MODEL": {"string":"iPhone 11 Pro"},"EVENT": {"string":"dropped"},"STATE": {"string":"NSW"},"LONG": {"double":151.25664},"LAT": {"double":-33.85995}}
    
Generate random data with [jr](https://github.com/ugol/jr) and kafka-avro-console-producer
       
    docker exec -i jr-cli jr run -f 1000ms -l  event_template| docker exec -i schema-registry kafka-avro-console-producer --broker-list broker:29092 --topic phone_event_raw --property schema.registry.url=http://localhost:8081 --property value.schema.id=$SCHEMA_ID

Recevice messages:

    docker exec -i schema-registry kafka-avro-console-consumer --bootstrap-server broker:29092     --topic phone_event_raw


## Interact with data

Use the ksqldb cli:

    docker exec -it ksqldb-cli ksql http://ksqldb-server:8088


  SELECT IEV_CUSTOMER_NAME, IEV_LONG, IEV_LAT, RCT_LONG, RCT_LAT FROM insurance_event_with_repair_info EMIT CHANGES LIMIT 2;
  
