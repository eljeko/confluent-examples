
# RBAC Demo

The demo will use these users:

controlcenterAdmin -> Cluster administrator
alice -> will be promoted to roles administrator
barnie -> will be given Resource owner to topic notifications
charlie -> can't see antyhing

# Control Center

Explore control center with user:

U: controlcenterAdmin
P: controlcenterAdmin


Login in control center http://localhost:9021/login as:

U: alice
P: alice-secret

Show that user can't see anything.

# Setup RBAC for topic notifications

## Prepare tools container with certificates

Before all copy the certificates into tools container

```
docker cp scripts/security/barnie.key tools:/barnie.key
docker cp scripts/security/barnie.certificate.pem tools:/barnie.certificate.pem
docker cp scripts/security/charlie.key tools:/charlie.key
docker cp scripts/security/charlie.certificate.pem tools:/charlie.certificate.pem
docker cp scripts/security/snakeoil-ca-1.crt tools:/snakeoil-ca-1.crt
```

## Login into tools container

Enter tools container

    docker exec -it tools bash

Update the confluent cli:

    curl --http1.1 -L https://cnfl.io/cli | sh -s -- -b /usr/bin v3.0.1

Login into MDS

    confluent login --url https://kafka1:8091

with user:

    U: mds
    P: mds


Show roles list

    confluent iam rbac role list --output json | jq '.[].name'

Inspect a role

    confluent iam rbac role describe DeveloperRead

    confluent iam rbac role describe DeveloperRead -o json|jq

Set CLUSTER_ID env:

    export KAFKA_CLUSTER_ID=$(confluent cluster describe --url https://kafka1:8091 -o json |jq -r .scope[0].id) && echo $KAFKA_CLUSTER_ID

Show user Alice has non roles:

    confluent iam rbac role-binding list --principal User:alice --kafka-cluster $KAFKA_CLUSTER_ID

The default output is human readable

Output with json

    confluent iam rbac role-binding list --principal User:alice --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq


## Promote Alice to userAdmin role

    confluent iam rbac role-binding create --principal User:alice --role UserAdmin --kafka-cluster $KAFKA_CLUSTER_ID

Check again Alice role bindings (You can add -o json or yaml now to see the output):

    confluent iam rbac role-binding list --principal User:alice --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq

**Logout alice from Control Center**

# Login with barnie into Control Center

Show he can't see anything on control center


# Create new topic notifications

Logout cli:

    confluent logout

Login as contolcenter admin:

    confluent login --url https://kafka1:8091

    U: controlcenterAdmin
    P: controlcenterAdmin

Create new topic (with through REST proxy)

    confluent kafka topic create notifications --partitions 2 --replication-factor 1 --url https://restproxy:8086

# login in Control Center

Login in control center with user:

    U: barnie
    P: barnie-secret

Shows barnie can't see anything

# test barnie from cli

Try to consume message from notifications with barnie, you receive an error.

## Connect SSL

Consume messages with barnie (you can't consume and receive and error):

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location barnie.certificate.pem --key-location barnie.key

Back to tools container shell, Logout admin:

    confluent logout

Login as Alice:

    confluent login --url https://kafka1:8091

    U: alice
    P: alice-secret

Allow barnie group to access ReST api:

    confluent kafka acl create --allow --principal "User:barnie" --operation READ --consumer-group "*" --url https://restproxy:8086

Assign to Barnie the role ResourceOwner on the new topic

Assaing the role ResourceOwner on topic notification to barnie:

    confluent iam rbac role-binding create --principal User:barnie --role ResourceOwner --resource Topic:notifications --kafka-cluster $KAFKA_CLUSTER_ID

Check the roles

    confluent iam rbac role-binding list --principal User:alice --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq

## Test again with correct roles for barnie

Consume messages again with barnie:

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location barnie.certificate.pem --key-location barnie.key

Show Barnie in control center

    confluent login --url https://kafka1:8091

    U: barnie
    P: barnie-secret

## Test again with charlie

Allow charlie to interact with API

    confluent kafka acl create --allow --principal "User:charlie" --operation READ --consumer-group "*" --url https://restproxy:8086

Consume messages with charlie:

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location charlie.certificate.pem --key-location charlie.key

Charlie can't access the topic


# Non interactive login

Login can be accomplished non-interactively using the 

* CONFLUENT_PLATFORM_USERNAME
* CONFLUENT_PLATFORM_PASSWORD
* CONFLUENT_PLATFORM_MDS_URL
* CONFLUENT_PLATFORM_CA_CERT_PATH 

environment variables.

In a non-interactive login,```CONFLUENT_PLATFORM_MDS_URL``` replaces the --url flag, and ```CONFLUENT_PLATFORM_CA_CERT_PATH``` replaces the --ca-cert-path flag.

[Here the documentation](https://docs.confluent.io/confluent-cli/current/command-reference/confluent_login.html)


# Non interactive user list

    confluent logout

    export CONFLUENT_PLATFORM_USERNAME=alice
    export CONFLUENT_PLATFORM_PASSWORD=alice-secret
    export CONFLUENT_PLATFORM_MDS_URL=https://kafka1:8091

    confluent login

    export KAFKA_CLUSTER_ID=$(confluent cluster describe --url https://kafka1:8091 -o json |jq -r .scope[0].id) && echo $KAFKA_CLUSTER_ID

    confluent iam rbac role-binding list --kafka-cluster $KAFKA_CLUSTER_ID  --principal User:barnie  --role ResourceOwner -o json|jq

    confluent iam user list  --kafka-cluster $KAFKA_CLUSTER_ID

# sample client.properties

    sasl.mechanism = PLAIN
    security.protocol = SASL_SSL
    sasl.jaas.config = org.apache.kafka.common.security.plain.PlainLoginModule required username="barnie" password="barnie-secret";
    ssl.truststore.location=/home/training/rbac/security/tls/kafka-client/kafka-client.truststore.jks
    ssl.truststore.password=confluent


# Customize demo

To add more user add the name in the script certs-create.sh to create the certificates for them.
