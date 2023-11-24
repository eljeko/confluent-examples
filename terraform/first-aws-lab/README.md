# Terraform

1. run `terraform init` to init the tool and the project
2. run `terraform plan` to check that at least every resource is formally correct and the terraform can be run


Check the final output
    
    terraform output

Synch local stae with remote

    terraform refresh

Update a var in cli

    terraform apply -var owner=test

Update with custom tfvars

    terraform apply -var-file custom.tfvars


This terraform can runs with:

    terraform plan -var date_updated=2023-11-21

Rmeber to add your keypair to AWS console, this will be used 

Then can apply all

    terraform apply -var date_updated=2023-11-21

    terraform state list

If everything went well you can connect to your instance with:

ssh ec2-user@<your-machine>.<region>.compute.amazonaws.com

# Destroy specific resource

    terraform state list

check the resource list

    aws_instance.demo
    aws_internet_gateway.lab
    aws_route.lab_default_route
    aws_security_group.allow_ssh
    aws_subnet.lab["az1"]
    aws_subnet.lab["az2"]
    aws_subnet.lab["az3"]
    aws_vpc.lab

Destroy a specific one:

    terraform destroy -target="aws_instance.demo"


    terraform destroy -var date_updated=2023-11-21