# Live Driver GPS demo

This demo is heavily based on [sylhare repo](https://github.com/sylhare/kafka)

NOTE: This demo is still in development and unstable.

## Build node-confluent-librdkafka base image

This is the base inmage with the UI of the demo, is based on Nodejs and contains node client with librdkafka.

Beforse running the whole demo you need to build the base image as follow:

    ./01_build_node_confluent_librdkafka.sh

The script runs for you:

    docker build -t node-confluent-librdkafka .

In the `node-front-end` dir.

## Start docker compose

    ./start-cluster.sh


# prodcue mesages

    cd java-client
     
    mvn clean package

    java -jar target/driver-position-sender-1.0-SNAPSHOT-jar-with-dependencies.jar driver-1.csv driver1.properties  

# Check the gui

    Go to http://localhost:3001

# Known issues!

## nodejs package-lock.json

When building the image be sure that there is no `package-lock.json` on the path

## Javascript io

You may have problem with websocket version mismatch between browser client and nodejs server side, check the version and eventually update `node-front-end`.

Reference javascript socketio: https://socket.io/docs/v4/client-installation/


