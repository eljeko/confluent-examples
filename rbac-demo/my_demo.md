docker-compose exec connect kafka-avro-console-consumer \
  --bootstrap-server kafka1:11091,kafka2:11092 \
  --property basic.auth.credentials.source=USER_INFO \
  --property basic.auth.user.info=alice:alice-secret \
  --group wikipedia.test \
  --topic alicetopic \
  --max-messages 1