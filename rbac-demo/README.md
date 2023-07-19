# Init the Demo

## Prepare udpated tools container

From the project root run the docker build for new tools container:

```docker build -f tools/Dockerfile-tools -t cnfldemos/tools:3.0.1 --no-cache . ```

## Start the cluster 

Before you start you need to run ```start.sh``` in the [scripts folder](scripts/start.sh)

This will prepare:

* Containers
    * openldap 
    * zookeeper 
    * kafka1 
    * kafka2 
    * schemaregistry 
    * control-center
    * tools
* Create the certificates for components and users
* Creating role bindings for principals


# To start

cd script and run:

    start.sh

If you need you can clean the demo filesystem setting the envrionment variable:

    CLEAN=true

This will regenerates certificates and strat all from scratch

# Note

This demo is based on [Scripted Confluent Platform Demo](https://docs.confluent.io/platform/current/tutorials/cp-demo/docs/overview.html)

Github repo [here](https://github.com/confluentinc/cp-demo)