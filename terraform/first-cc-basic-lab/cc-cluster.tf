# --------------------------------------------------------
# Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "simple_cluster" {
    display_name = "${local.cluster_name}"
    availability = "SINGLE_ZONE"
    cloud = "AWS"
    region = "eu-south-1"
    basic {}
    environment {
        id = confluent_environment.simple_env.id
    }
    lifecycle {
        prevent_destroy = false
    }
}