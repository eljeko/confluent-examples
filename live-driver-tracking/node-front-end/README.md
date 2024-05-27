# Build the image

    docker build -t node-confluent-librdkafka .

# run the istance

    docker run --name live-demo-gps-ui -p 3000:3000 -it node-confluent-librdkafka npm start