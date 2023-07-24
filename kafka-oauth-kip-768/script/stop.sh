#!/bin/bash

echo "Stopping docker containers..."
docker-compose -f ../docker-compose-idp.yml --env-file .env down --volumes
docker-compose -f ../docker-compose-oauth.yml --env-file .env down --volumes