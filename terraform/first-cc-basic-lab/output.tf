output "build" {
  value = {
    app_manager_kafka_cluster_key_KEY       = confluent_api_key.app_manager_kafka_cluster_key.id,
    app_manager_kafka_cluster_key_SECRET    = nonsensitive(confluent_api_key.app_manager_kafka_cluster_key.secret),

    sr_cluster_key_KEY                      = confluent_api_key.sr_cluster_key.id,
    sr_cluster_key_SECRET                   = nonsensitive(confluent_api_key.sr_cluster_key.secret),
    
    clients_kafka_cluster_key_KEY           = confluent_api_key.clients_kafka_cluster_key.id,
    clients_kafka_cluster_key_SECRET        = nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret),
    
  }
   
}