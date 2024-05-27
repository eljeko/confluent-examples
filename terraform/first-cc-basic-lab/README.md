# Set through env vars API KEY and API SECRET

    CONFLUENT_CLOUD_API_KEY="CLOUD-KEY"
    CONFLUENT_CLOUD_API_SECRET="CLOUD-SECRET"

Then let's start using terraform and init dependencies

    terraform init

Let's check our plan

    terraform plan

To run the apply without promopt

    terraform apply -var confluent_cloud_api_key=<your-key> -var confluent_cloud_api_secret=<your-secret> -auto-approve 

Destroy the cluster:

    terraform destroy -auto-approve 

NOTE: this terraform project will print on standard output the API KEY secrets, this will could be a potential security issue for a production environment