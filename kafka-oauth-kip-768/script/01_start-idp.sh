
#!/bin/bash

echo "Starting IDP... "
docker-compose -f ../docker-compose-idp.yml --env-file .env up -d