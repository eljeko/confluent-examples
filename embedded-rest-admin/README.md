# Start docker

    docker-compose up -d

Wait for the components to startup:

* broker
* schema-registry
* zookeeper

control-center is commented, uncomment it to play with the UI while exeperimenting with REST API

The rest url will be [http://localhost:8090/kafka/v3/clusters](http://localhost:8090/kafka/v3/clusters)

# Play with topics

This mini tutorial uses [jq](https://jqlang.github.io/jq/)

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

Describe the topic

    curl --silent -X GET http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics/test-rest-topic | jq


Output should be:

    _confluent-command
    _schemas
    test-rest-topic

Create a topic with specific configuration from file

    curl --silent -X POST -H "Content-Type: application/json" -d @topic-configured http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics | jq

Check topic created

    curl --silent -X GET http://localhost:8090/kafka/v3/clusters/$CLUSTER_ID/topics/topic-configured | jq
