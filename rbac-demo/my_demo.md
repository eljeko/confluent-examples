
# sample client.properties

    sasl.mechanism = PLAIN
    security.protocol = SASL_SSL
    sasl.jaas.config = org.apache.kafka.common.security.plain.PlainLoginModule required username="barnie" password="barnie-secret";
    ssl.truststore.location=/home/training/rbac/security/tls/kafka-client/kafka-client.truststore.jks
    ssl.truststore.password=confluent


# Avro test    

docker-compose exec connect kafka-avro-console-consumer \
  --bootstrap-server kafka1:11091,kafka2:11092 \
  --property basic.auth.credentials.source=USER_INFO \
  --property basic.auth.user.info=alice:alice-secret \
  --group wikipedia.test \
  --topic alicetopic \
  --max-messages 1




  confluent iam rbac role-binding create --principal superUser --role SystemAdmin --kafka-cluster $KAFKA_CLUSTER_ID --schema-registry-cluster-id $SR