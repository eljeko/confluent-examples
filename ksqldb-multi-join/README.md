# Run the demo

docker-compose --env-file env up -d

# Setup the tables and streams

Run this command to create the main Table and the streams:

    docker exec -it ksqldb-cli ksql http://ksqldb-server:8088 -f /home/appuser/ksql-setup.sql

# Insert data into the table

we insert 10 events in the main topic/table

    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('NC355NQ', 'Ford', '3478337573', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('AF803LQ', 'Ford', '2772222845', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('GE330JV', 'FIAT', '6560182934', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('CU378IG', 'BMW', '8885597954', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('NN615YG', 'BMW', '5716990050', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('BZ363UA', 'FIAT', '2184898292', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('ZT186ZN', 'FIAT', '4126549043', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('IM285DV', 'Ford', '0078260938', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('JN590TX', 'Ford', '0416321844', 'IT');
    INSERT INTO plates_car_ingest_table (plate_number, car_model, doc_id, state) VALUES ('BH701LP', 'Mercedes', '7556858249', 'IT');

# Start listening the notification output

    docker exec -i schema-registry kafka-avro-console-consumer --bootstrap-server  broker:9092 --topic  PLATES_NOTIFICATIONS --property  print.key=true --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer


# Insert data into plates_car_validation

Insert one or more of these entries:

    INSERT INTO plates_car_validation (plate_number, validation) VALUES ('NC355NQ', 'validated');

    INSERT INTO plates_car_validation (plate_number, validation) VALUES ('AF803LQ', 'validated');

    INSERT INTO plates_car_validation (plate_number, validation) VALUES ('GE330JV', 'validated');

    INSERT INTO plates_car_validation (plate_number, validation) VALUES ('CU378IG', 'validated');


# Insert data into plates_car_output

Insert one or more of these entries:

    INSERT INTO plates_car_output (plate_number, recipient) VALUES ('NC355NQ', 'NC355NQ@recipient.xyz');

    INSERT INTO plates_car_output (plate_number, recipient) VALUES ('AF803LQ', 'AF803LQ@recipient.xyz');

    INSERT INTO plates_car_output (plate_number, recipient) VALUES ('GE330JV', 'GE330JV@recipient.xyz');

    INSERT INTO plates_car_output (plate_number, recipient) VALUES ('CU378IG', 'CU378IG@recipient.xyz');


# Check the output

You should receive an output join message on topic PLATES_NOTIFICATIONS once each topic had received at least a messages.