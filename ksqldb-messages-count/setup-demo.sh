docker exec -i broker kafka-topics --bootstrap-server broker:9092 --topic orders --create --partitions 3 --replication-factor 1

docker exec -it ksqldb-cli ksql http://ksqldb-server:8088 -f /home/appuser/ksql-setup.sql