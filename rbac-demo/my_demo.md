
# sample client.properties

    sasl.mechanism = PLAIN
    security.protocol = SASL_SSL
    sasl.jaas.config = org.apache.kafka.common.security.plain.PlainLoginModule required username="barnie" password="barnie-secret";
    ssl.truststore.location=/home/training/rbac/security/tls/kafka-client/kafka-client.truststore.jks
    ssl.truststore.password=confluent


  confluent iam rbac role-binding create --principal superUser --role SystemAdmin --kafka-cluster $KAFKA_CLUSTER_ID --schema-registry-cluster-id $SR

  confluent iam rbac role-binding create --principal Group:KafkaDevelopers --role ResourceOwner --resource Topic:notification --kafka-cluster $KAFKA_CLUSTER_ID

  confluent iam rbac role-binding list --principal Group:KafkaDevelopers  --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq

# copy files in broker container

    docker cp scripts/security/kafka.barnie.truststore.jks kafka1:/home/appuser/kafka.barnie.truststore.jks
    docker cp scripts/security/kafka.barnie.keystore.jks kafka1:/home/appuser/kafka.barnie.keystore.jks
    docker cp user-tests/barnie.properties kafka1:/home/appuser/barnie.properties

# Authentication and authorization with group

Enter the broker contaienr `docker exec -it kafka1 bash`:

    kafka-topics --bootstrap-server kafka1:11091 --command-config /home/appuser/barnie.properties --describe --topic notification

The user/group can't describe the topic

In tools container enable Resource ownership for group `docker exec -it tools bash`:

    confluent iam rbac role-binding create --principal Group:KafkaDevelopers --role ResourceOwner --resource Topic:notification --kafka-cluster-id $KAFKA_CLUSTER_ID

The user/group now can describe the topic

    kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic notification

But the user/group can't consume message:

    kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic notification

In tools container enable ACL for group:

    confluent kafka acl create --allow --principal "Group:KafkaDevelopers" --operation READ --consumer-group "*" --url https://kafka1:8091/kafka/

Back to Kafka1 container:

    kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic notification 

This works because the user `barnie` belongs to the group KafkaDevelopers

  kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic notification --consumer-property group.id=KafkaDevelopers

  kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic notification
  



