docker-compose exec connect kafka-avro-console-consumer \
  --bootstrap-server kafka1:11091,kafka2:11092 \
  --property basic.auth.credentials.source=USER_INFO \
  --property basic.auth.user.info=alice:alice-secret \
  --group wikipedia.test \
  --topic alicetopic \
  --max-messages 1




  confluent iam rbac role-binding create --principal superUser --role SystemAdmin --kafka-cluster $KAFKA_CLUSTER_ID --schema-registry-cluster-id $SR