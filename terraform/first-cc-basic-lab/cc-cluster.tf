# --------------------------------------------------------
# Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "simple_cluster" {
  display_name = local.cluster_name
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "eu-south-1"
  basic {}
  environment {
    id = confluent_environment.simple_env.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.simple_cluster.id
  }
  topic_name    = "orders"
  rest_endpoint = confluent_kafka_cluster.simple_cluster.rest_endpoint
  
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
