CREATE TABLE plates_car_ingest_table (plate_number VARCHAR PRIMARY KEY, car_model VARCHAR, doc_id VARCHAR, state VARCHAR) WITH (kafka_topic='plates_ingest', value_format='avro', partitions=3);
CREATE STREAM  plates_car_validation (plate_number VARCHAR, validation VARCHAR) WITH (kafka_topic='plates_validation', value_format='avro', partitions=3);
CREATE STREAM  plates_car_output (plate_number VARCHAR, recipient VARCHAR) WITH (kafka_topic='plates_output', value_format='avro', partitions=3);

CREATE STREAM plates_notifications AS
SELECT 
    plates_car_ingest_table.plate_number AS plate_number, 
    plates_car_ingest_table.car_model AS car_model, 
    plates_car_ingest_table.doc_id AS doc_id, 
    plates_car_validation.validation AS validation,
    plates_car_output.recipient AS recipient    
FROM plates_car_output
LEFT JOIN plates_car_ingest_table  ON plates_car_output.plate_number= plates_car_ingest_table.plate_number
LEFT JOIN plates_car_validation WITHIN 1 MINUTE ON plates_car_output.plate_number = plates_car_validation.plate_number;