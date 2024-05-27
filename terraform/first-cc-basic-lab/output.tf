output "build" {
  /*value = {
    R_01_app_manager_kafka_cluster_key_KEY       = confluent_api_key.app_manager_kafka_cluster_key.id,
    R_01_app_manager_kafka_cluster_key_SECRET    = nonsensitive(confluent_api_key.app_manager_kafka_cluster_key.secret),

    R_02_sr_cluster_key_KEY                      = confluent_api_key.sr_cluster_key.id,
    R_02_sr_cluster_key_SECRET                   = nonsensitive(confluent_api_key.sr_cluster_key.secret),
    
    R_03_clients_kafka_cluster_key_KEY           = confluent_api_key.clients_kafka_cluster_key.id,
    R_03_clients_kafka_cluster_key_SECRET        = nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret),
    
    R_04_____cluster_url                         = confluent_kafka_cluster.simple_cluster.bootstrap_endpoint
  }*/

  value = <<-EOT

  ########################################
  #       Cluster Setup Info             #
  ########################################

  Environment ID: ${confluent_environment.simple_env.id}
  
  Kafka Cluster
  ID: ${confluent_kafka_cluster.simple_cluster.id}
  Bootstrap URL: ${confluent_kafka_cluster.simple_cluster.bootstrap_endpoint}
     Topic name: [${confluent_kafka_topic.orders.topic_name}]

  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):

  ${confluent_service_account.app_manager.display_name}
       SA ID: ${confluent_service_account.app_manager.id}
     API Key: "${confluent_api_key.app_manager_kafka_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.app_manager_kafka_cluster_key.secret)}"

  ${confluent_service_account.sr.display_name} 
       SA ID: ${confluent_service_account.sr.id}
     API Key: "${confluent_api_key.sr_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.sr_cluster_key.secret)}"

  ${confluent_service_account.clients.display_name}
       SA ID: ${confluent_service_account.clients.id}
     API Key: "${confluent_api_key.clients_kafka_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret)}"


  EOT

}
