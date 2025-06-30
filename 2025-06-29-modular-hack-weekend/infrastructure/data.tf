# Data Sources
# Lambda Cloud Infrastructure Information

# Data source to get available instance types (optional, for validation)
data "lambdalabs_instance_types" "available" {}

# Try to lookup existing SSH key
data "lambdalabs_ssh_key" "existing_key" {
  name = var.ssh_key_name

  # This will fail gracefully if the key doesn't exist
  # We'll handle the error in locals
}
