 # RBAC API example

MDS API documentation [here](https://docs.confluent.io/platform/current/security/rbac/mds-api.html)

## Access Token Retrieval
    
    export TOKEN=$(curl -u controlcenterAdmin:controlcenterAdmin https://kafka1:8091/security/1.0/authenticate|jq -r .auth_token) && echo $TOKEN

    export KAFKA_CLUSTER_ID=$(curl -u mds:mds https://kafka1:8091/security/1.0/metadataClusterId) && echo $KAFKA_CLUSTER_ID    

# Cluster info

Access Token Retrieval

    export TOKEN=$(curl -u controlcenterAdmin:controlcenterAdmin https://kafka1:8091/security/1.0/authenticate|jq -r .auth_token) && echo $TOKEN

Test with cluster info:

    curl https://kafka1:8091/kafka/v3/clusters -H "Accept: application/json" -H "Authorization: Bearer $TOKEN"|jq

Get cluster ID:

    export KAFKA_CLUSTER_ID=$(curl https://kafka1:8091/kafka/v3/clusters -H "Accept: application/json" -H "Authorization: Bearer $TOKEN"| jq -r '.data[].cluster_id') && echo $KAFKA_CLUSTER_ID

Get roles:    

    curl https://kafka1:8091/security/1.0/roles -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" | jq '.[].name'


    curl -u alice:alice-secret https://kafka1:8091/security/1.0/roles

    curl -u alice:alice-secret https://kafka1:8091/kafka/v3/clusters


Some more complex interactions:

    export JSON_REQUEST $(echo '{\"clusterName\": \"$KAFKA_CLUSTER_ID\" }')&& echo $JSON_REQUEST 

    USER_ROLES_JSON=$(cat <<EOF
    {"clusters":{"kafka-cluster":"$KAFKA_CLUSTER_ID"}}
    EOF
    ) && echo $USER_ROLES_JSON
    
    curl -X POST https://kafka1:8091/security/1.0/lookup/principal/User:barnie/resources -H 'Content-Type: application/json' -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" -d $USER_ROLES_JSON |jq
    
    curl -X POST https://kafka1:8091/security/1.0/lookup/principal/User:alice/resources -H 'Content-Type: application/json' -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" -d $USER_ROLES_JSON |jq



    curl -X POST https://kafka1:8091/security/1.0/lookup/principal/Group:KafkaDevelopers/resources -H 'Content-Type: application/json' -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" -d $USER_ROLES_JSON |jq
