terraform {
    required_providers {
        confluent = {
            source = "confluentinc/confluent"
            version = "1.55.0"
        }
    }
}

# --------------------------------------------------------
# This 'random_id' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
    byte_length = 4
}