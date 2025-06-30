# Data Sources
# Lambda Cloud Infrastructure Information

# Data source to get available instance types (optional, for validation)
data "lambdalabs_instance_types" "available" {}

# Try to lookup existing SSH key (optional - won't fail if key doesn't exist)
data "lambdalabs_ssh_key" "existing_key" {
  count = try(length(var.ssh_key_name) > 0, false) ? 1 : 0
  name  = var.ssh_key_name

  # Using count makes this lookup optional
  # If the key doesn't exist, this data source won't be created
}
