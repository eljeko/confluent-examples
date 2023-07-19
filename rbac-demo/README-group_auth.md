# Group authorization tutorial
## OPTIONAL: This should be done during the execution of start.sh
 
copy files in broker `kafka1` container

    docker cp scripts/security/kafka.barnie.truststore.jks kafka1:/home/appuser/kafka.barnie.truststore.jks
    docker cp scripts/security/kafka.barnie.keystore.jks kafka1:/home/appuser/kafka.barnie.keystore.jks
    docker cp user-tests/barnie.properties kafka1:/home/appuser/barnie.properties

# Ldap check

You can check the ldap users/group with:

    docker exec -it openldap  ldapsearch -x -b "ou=groups,dc=confluentdemo,dc=io" -H ldap://localhost -D "cn=admin,dc=confluentdemo,dc=io" -w admin

# Create the topic `devnotifications`

Create the topic:

    docker exec -i tools /bin/bash -c "export CONFLUENT_PLATFORM_USERNAME=controlcenterAdmin && export CONFLUENT_PLATFORM_PASSWORD=controlcenterAdmin &&  export CONFLUENT_PLATFORM_MDS_URL=https://kafka1:8091 &&  confluent login --url https://kafka1:8091 && confluent kafka topic create devnotifications --partitions 2 --replication-factor 1 --url https://kafka1:8091/kafka/"


# Authentication and authorization with group

Enter the broker contaienr `docker exec -it kafka1 bash`:

    docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:11091 --command-config /home/appuser/barnie.properties --describe --topic devnotifications

The user/group can't describe the topic

In tools container enable Resource ownership for group `docker exec -it tools bash`:

Logout cli:

    confluent logout

Login as contolcenter admin:

    confluent login --url https://kafka1:8091

    U: controlcenterAdmin
    P: controlcenterAdmin

    export KAFKA_CLUSTER_ID=$(confluent cluster describe --url https://kafka1:8091 -o json |jq -r .scope[0].id) && echo $KAFKA_CLUSTER_ID

    confluent iam rbac role-binding create --principal Group:KafkaDevelopers --role ResourceOwner --resource Topic:devnotifications --kafka-cluster $KAFKA_CLUSTER_ID

The user/group now can describe the topic

    docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:11091 --command-config /home/appuser/barnie.properties --describe --topic devnotifications

But the user/group can't consume message:

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic devnotifications

In tools container enable ACL for group with every consumer group name:

    confluent kafka acl create --allow --principal "Group:KafkaDevelopers" --operation READ --consumer-group "*" --url https://kafka1:8091/kafka/

Back to Kafka1 container:

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic devnotifications 

This works because the user `barnie` belongs to the group KafkaDevelopers

# Clean

    confluent kafka acl delete --url https://kafka1:8091/kafka/ --allow --principal "Group:KafkaDevelopers" --operation READ --consumer-group "*" --host "*"

    confluent iam rbac role-binding delete --principal "Group:KafkaDevelopers"  --role ResourceOwner --resource Topic:devnotifications --kafka-cluster $KAFKA_CLUSTER_ID

This is if you alredy did this tutorial

    confluent iam rbac role-binding delete --principal Group:KafkaDevelopers --role DeveloperRead --resource Group:dev-01 --kafka-cluster $KAFKA_CLUSTER_ID

# Access without using ACL

    confluent iam rbac role-binding create --principal "Group:KafkaDevelopers"  --role ResourceOwner --resource Topic:devnotifications --kafka-cluster $KAFKA_CLUSTER_ID

Test if the group can describe the topic

    docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:11091 --command-config /home/appuser/barnie.properties --describe --topic devnotifications

Assing other roles and consumer group dev-01:

    confluent iam rbac role-binding create --principal Group:KafkaDevelopers --role DeveloperRead --resource Group:dev-01 --kafka-cluster $KAFKA_CLUSTER_ID

Consume as barnie (that belongs to KafkaDevelopers) with authorized consumer group dev-01

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/barnie.properties --topic devnotifications --group dev-01
    
# check roles

check barine roles

     confluent iam rbac role-binding list --principal Group:KafkaDevelopers  --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq

Should be:

```
[
  {
    "principal": "Group:KafkaDevelopers",
    "role": "DeveloperRead",
    "resource_type": "Group",
    "name": "dev-01",
    "pattern_type": "LITERAL"
  },
  {
    "principal": "Group:KafkaDevelopers",
    "role": "ResourceOwner",
    "resource_type": "Topic",
    "name": "devnotifications",
    "pattern_type": "LITERAL"
  }
]
```

Barnie belongs to group KafkaDevelopers that is resource owner of the topic and KafkaDevelopers is DeveloperRead for Group (consumer group) dev-01

# Test badapp

Consume as barnie (that belongs to KafkaDevelopers) with authorized consumer group dev-01

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/badapp.properties --topic devnotifications --group dev-01

# Grant Access to badapp without using ACL

Bad app belongs to another group 

    confluent iam rbac role-binding create --principal "Group:KafkaOperations"  --role ResourceOwner --resource Topic:devnotifications --kafka-cluster $KAFKA_CLUSTER_ID

Test if the group can describe the topic

    docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:11091 --command-config /home/appuser/badapp.properties --describe --topic devnotifications

Assing other roles and consumer group dev-01:

    confluent iam rbac role-binding create --principal Group:KafkaOperations --role DeveloperRead --resource Group:ops-01 --kafka-cluster $KAFKA_CLUSTER_ID

Try consumer ad dev-01 (it fails):

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/badapp.properties --topic devnotifications --group dev-01

Consume as badapp (that belongs to KafkaOperations) with authorized consumer group ops-01

    docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:11091 --consumer.config /home/appuser/badapp.properties --topic devnotifications --group ops-01
    
check badapp roles

     confluent iam rbac role-binding list --principal Group:KafkaOperations  --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq


# Clean badapp

    confluent iam rbac role-binding delete --principal "Group:KafkaOperations"  --role ResourceOwner --resource Topic:devnotifications --kafka-cluster $KAFKA_CLUSTER_ID

This is if you alredy did this tutorial

    confluent iam rbac role-binding delete --principal Group:KafkaOperations --role DeveloperRead --resource Group:ops-01 --kafka-cluster $KAFKA_CLUSTER_ID

