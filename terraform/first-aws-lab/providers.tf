provider "aws" {
    region = var.region
}

locals {
  tf_tags = {
    "tf_owner"         = "Stefano Linguerri",
    "tf_owner_email"   = "slinguerri@confluent.io",
    "tf_provenance"    = "github.com/eljeko",
    "tf_last_modified" = "${var.date_updated}",
    "Owner"            = "Stefano Linguerri",
  }
}