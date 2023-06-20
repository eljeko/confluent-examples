# Start docker

    docker-compose up -d

Wait for the components to startup:

* broker
* schema-registry
* zookeeper

control-center is commented, uncomment it to play with the UI while exeperimenting with REST API

The rest url will be [http://localhost:8090/kafka/v3/clusters]()


# Play with topics

set cluster_id variable

    CLUSTER_ID=$(curl --silent -X GET http://localhost:8090/kafka/v3/clusters|jq -r '.data[].cluster_id')

Get topics list

    curl --silent -X GET http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics|jq -r '.data[].topic_name'

Output should be:

    _confluent-command
    _schemas

Create a simple topic

    curl --silent -X POST -H "Content-Type: application/json" --data '{"topic_name": "test-rest-topic"}' http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics | jq

Get topics list again

    curl --silent -X GET http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics|jq -r '.data[].topic_name'

Output should be:

    _confluent-command
    _schemas
    test-rest-topic