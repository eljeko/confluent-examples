
# RBAC Demo

The demo will use these users:

* controlcenterAdmin -> Cluster administrator
* alice -> will be promoted to roles administrator
* barnie -> will be given Resource owner to topic notifications
* charlie -> can't see anything

# Control Center

Explore control center with user:

U: controlcenterAdmin

P: controlcenterAdmin


Login in control center http://localhost:9021/login as:

U: alice
P: alice-secret

Show that user can't see anything.

# Setup RBAC for topic notifications

## ## OPTIONAL: This should be done during the execution of start.sh

Prepare tools container with certificates

Before all copy the certificates into tools container

```
docker cp scripts/security/barnie.key tools:/barnie.key
docker cp scripts/security/barnie.certificate.pem tools:/barnie.certificate.pem
docker cp scripts/security/charlie.key tools:/charlie.key
docker cp scripts/security/charlie.certificate.pem tools:/charlie.certificate.pem
docker cp scripts/security/snakeoil-ca-1.crt tools:/snakeoil-ca-1.crt
```

## Login into tools container

Enter tools container (see the guide on how to build the updated container in the folder ```tools```):

    docker exec -it tools bash

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

Logout cli:

    confluent logout

Login as contolcenter alice:

    confluent login --url https://kafka1:8091

    U: alice
    P: alice-secret

Try to create a topic with alice (should **fail**):

    confluent kafka topic create notifications --partitions 2 --replication-factor 1 --url https://kafka1:8091/kafka/

Or

    confluent kafka topic create notifications --partitions 2 --replication-factor 1 --url https://restproxy:8086    

**It fails**

**Logout alice from Control Center**

# Create new topic notifications

Logout cli:

    confluent logout

Login as contolcenter admin:

    confluent login --url https://kafka1:8091

    U: controlcenterAdmin
    P: controlcenterAdmin

Create new topic (through REST proxy)

    confluent kafka topic create notifications --partitions 2 --replication-factor 1 --url https://kafka1:8091/kafka/

Or

    confluent kafka topic create notifications --partitions 2 --replication-factor 1 --url https://restproxy:8086


Then logout controlcenterAdmin user
    
    confluent logout

# login in Control Center

Login in control center with user:

    confluent login --url https://kafka1:8091

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

Allow group to access:

    confluent kafka acl create --allow --principal "User:barnie" --operation READ --consumer-group "*" --url https://kafka1:8091/kafka/

Or

    confluent kafka acl create --allow --principal "User:barnie" --operation READ --consumer-group "*" --url https://restproxy:8086

Assign to Barnie the role ResourceOwner on the new topic

Assaing the role ResourceOwner on topic notification to barnie:

    confluent iam rbac role-binding create --principal User:barnie --role ResourceOwner --resource Topic:notifications --kafka-cluster $KAFKA_CLUSTER_ID

Check the roles

    confluent iam rbac role-binding list --principal User:barnie --kafka-cluster $KAFKA_CLUSTER_ID -o json|jq

Then logout alice user
    
    confluent logout

## Test again with correct roles for barnie

Consume messages again with barnie:

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location barnie.certificate.pem --key-location barnie.key

Login in Confluent Control http://localhost:9021/ as barnie:

    U: barnie
    P: barnie-secret

Send message on topic notification in Control Center

Then logout alice user
    
    confluent logout


## Test again with charlie

Consume messages with charlie:

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location charlie.certificate.pem --key-location charlie.key

Charlie can't access the topic

### Allow charlie to access the topic without using ACL

Login in Confluent Control http://localhost:9021/ center as:

    U: controlcenterAdmin
    P: controlcenterAdmin

Login as Alice:

    confluent login --url https://kafka1:8091

    U: alice
    P: alice-secret

Allow for a specific group:

    confluent iam rbac role-binding create --principal User:charlie --role DeveloperRead --resource Group:dev-01 --kafka-cluster $KAFKA_CLUSTER_ID

Allow for topic:

    confluent iam rbac role-binding create --principal User:charlie --role ResourceOwner --resource Topic:notifications --kafka-cluster $KAFKA_CLUSTER_ID


Consume message with a specific group:

    confluent kafka topic consume notifications --protocol SSL --bootstrap "kafka1:11091" --ca-location snakeoil-ca-1.crt --cert-location charlie.certificate.pem --key-location charlie.key --group dev-01

# Acl


List:

    confluent kafka acl list  --url https://kafka1:8091/kafka/

Delete:

    confluent kafka acl delete --url https://kafka1:8091/kafka/ --allow --principal "User:charlie" --operation READ --consumer-group "*" --host "*"

Exit session

   confluent logout
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

Set the environment:

    export CONFLUENT_PLATFORM_USERNAME=alice
    export CONFLUENT_PLATFORM_PASSWORD=alice-secret
    export CONFLUENT_PLATFORM_MDS_URL=https://kafka1:8091

Login:

    confluent login

Execute some commands:

    confluent iam rbac role-binding list --kafka-cluster $KAFKA_CLUSTER_ID  --principal User:barnie  --role ResourceOwner -o json|jq

Get all the user for a role:

    confluent iam rbac role-binding list  --role ResourceOwner   --kafka-cluster $KAFKA_CLUSTER_ID

    confluent iam rbac role-binding list  --role ResourceOwner   --kafka-cluster $KAFKA_CLUSTER_ID -o json |jq

Other Roles:

    confluent iam rbac role-binding list  --role UserAdmin   --kafka-cluster $KAFKA_CLUSTER_ID -o json |jq

# Customize demo

To add more user add the name in the script certs-create.sh to create the certificates for them.
