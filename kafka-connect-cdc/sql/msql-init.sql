CREATE DATABASE factory;
GO
USE factory;
EXEC sys.sp_cdc_enable_db;

create table sensors_readings (
	id integer PRIMARY KEY,
	sensor_id VARCHAR(50),
	sensor_ip VARCHAR(20),
	longitude VARCHAR(50),
	latitude VARCHAR(50),
	reading VARCHAR(50)
);

insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (1, 'SRN-7171', '185.188.156.122', 115.038835, 30.20003, '91');
insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (2, 'SRN-3111', '137.231.8.149', 113.078569, 23.41698, '61');
insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (3, 'SRN-5161', '150.161.233.244', 34.0761476, 45.0023182, '51');
insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (4, 'SRN-8151', '168.210.225.70', 120.992642, 14.570684, '54');
insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (5, 'SRN-4131', '217.220.49.217', 111.809478, 21.951497, '11');
insert into sensors_readings (id, sensor_id, sensor_ip, longitude, latitude, reading) values (6, 'SRN-2111', '159.243.148.244', 122.8993, 10.237, '21');

EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'sensors_readings', @role_name = NULL, @supports_net_changes = 0;
GO