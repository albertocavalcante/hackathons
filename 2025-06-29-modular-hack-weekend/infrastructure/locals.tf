# Local Values
# Strategic SSH Key Management and Configuration

locals {
  # Check if existing key exists and matches our public key
  existing_key_matches = try(data.lambdalabs_ssh_key.existing_key[0].public_key == var.ssh_public_key, false)
  should_create_key    = !local.existing_key_matches

  # Choose which SSH key ID to use (existing or new)
  ssh_key_name = local.existing_key_matches ? data.lambdalabs_ssh_key.existing_key[0].name : var.ssh_key_name

  # Startup script for GPU instance configuration
  startup_script = <<-EOF
    #!/bin/bash
    # Install additional dependencies for hackathon
    sudo apt-get update

    # Install Modular if not present
    pip install modular --index-url https://dl.modular.com/public/nightly/python/simple/ --extra-index-url https://download.pytorch.org/whl/cpu

    # Install additional Python packages
    pip install whisper-openai
    pip install tinygrad

    # Set up workspace directory
    mkdir -p /home/ubuntu/hackathon
    cd /home/ubuntu/hackathon

    echo "GPU instance ready for Modular hackathon development!"
    echo "Instance type: ${var.instance_type}"
    echo "Cost: ${lookup({
  "gpu_1x_rtx6000" = "$0.50/hour"
  "gpu_1x_a10"     = "$0.75/hour"
  "gpu_1x_v100"    = "$0.55/hour"
  "gpu_1x_a100"    = "$1.10/hour"
  "gpu_2x_a100"    = "$2.20/hour"
  "gpu_4x_a100"    = "$4.40/hour"
  "gpu_8x_a100"    = "$8.80/hour"
}, var.instance_type, "Unknown")}"
    echo "Remember to stop the instance when not in use!"
  EOF

# Common tags for all resources (if supported in future)
common_tags = {
  Project     = "modular-hackathon-jun-2025"
  Environment = "development"
  ManagedBy   = "terraform"
  Owner       = "hackathon-team"
}
}
