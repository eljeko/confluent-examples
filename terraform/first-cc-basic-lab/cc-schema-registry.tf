# --------------------------------------------------------
# Schema Registry
# --------------------------------------------------------
data "confluent_schema_registry_region" "simple_sr_region" {
    cloud = "AWS"
    region = "eu-central-1"
    package = "ESSENTIALS" 
}
resource "confluent_schema_registry_cluster" "simple_sr_cluster" {
    package = data.confluent_schema_registry_region.simple_sr_region.package
    environment {
        id = confluent_environment.simple_env.id 
    }
    region {
        id = data.confluent_schema_registry_region.simple_sr_region.id
    }
    lifecycle {
        prevent_destroy = false
    }
}