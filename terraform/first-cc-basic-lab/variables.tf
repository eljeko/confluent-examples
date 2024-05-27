locals {
    env_name = "terraform-playground-basic"
    cluster_name = "simple-basic-cluster"
    description = "Resource created for 'Simple Basic Cluster Terraform Playground"
}


variable "confluent_cloud_api_key" {
  default = "KEY"
}
variable "confluent_cloud_api_secret" {
  default = "SECRET"
}