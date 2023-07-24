
#!/bin/bash

echo "Starting Kafka cluster..."
docker-compose -f ../docker-compose-oauth.yml --env-file .env up -d

sleep 5

docker cp ../client-oauth.properties broker:/home/appuser/client-oauth.properties