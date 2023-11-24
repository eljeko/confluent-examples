
# Option #1: Manage multiple clusters in the same Terraform workspace
provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}

# -------------------------------------------------------
# Environment
# -------------------------------------------------------
resource "confluent_environment" "simple_env" {
    display_name = "${local.env_name}-${random_id.id.hex}"

    lifecycle {
        prevent_destroy = false
    }
}



