# Lambda Cloud Infrastructure Resources
# GPU Instance and SSH Key Management

# Create SSH key for the hackathon (only if needed)
resource "lambdalabs_ssh_key" "hackathon_key" {
  count = local.should_create_key ? 1 : 0

  name       = var.ssh_key_name
  public_key = var.ssh_public_key

  # Note: SSH key content is embedded as variable for Terraform Cloud compatibility
  # Original file location: ~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key.pub
  # To get content from file locally: trimspace(file("~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key.pub"))
}

# Provision the GPU instance
resource "lambdalabs_instance" "hackathon_gpu" {
  name               = var.instance_name
  region_name        = var.region
  instance_type_name = var.instance_type
  ssh_key_names      = [local.ssh_key_name]

  # Optional: Add file system if needed for persistent storage
  file_system_names = var.enable_file_system ? var.file_system_names : []

  # Note: Terraform will automatically handle dependencies for conditional resources
  # No explicit depends_on needed since we reference local.ssh_key_name
}
