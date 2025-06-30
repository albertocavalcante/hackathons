# Infrastructure Outputs
# Lambda Cloud GPU Instance Information

output "instance_id" {
  description = "Lambda Cloud instance ID"
  value       = lambdalabs_instance.hackathon_gpu.id
}

output "instance_ip" {
  description = "Public IP address of the GPU instance"
  value       = lambdalabs_instance.hackathon_gpu.ip
}

output "instance_type" {
  description = "Instance type provisioned"
  value       = lambdalabs_instance.hackathon_gpu.instance_type_name
}

output "instance_name" {
  description = "Instance name"
  value       = lambdalabs_instance.hackathon_gpu.name
}

output "region" {
  description = "Region where instance is deployed"
  value       = lambdalabs_instance.hackathon_gpu.region_name
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key ubuntu@${lambdalabs_instance.hackathon_gpu.ip}"
}

output "ssh_key_used" {
  description = "SSH key name used for the instance"
  value       = local.ssh_key_name
}

output "jupyter_url" {
  description = "Jupyter Lab URL (if available)"
  value       = "https://${lambdalabs_instance.hackathon_gpu.ip}:8888"
}

output "hourly_cost" {
  description = "Estimated hourly cost in USD"
  value = {
    "gpu_1x_rtx6000" = "$0.50/hour"
    "gpu_1x_a10"     = "$0.75/hour"
    "gpu_1x_v100"    = "$0.55/hour"
    "gpu_1x_a100"    = "$1.10/hour"
    "gpu_2x_a100"    = "$2.20/hour"
    "gpu_4x_a100"    = "$4.40/hour"
    "gpu_8x_a100"    = "$8.80/hour"
  }[var.instance_type]
}

output "setup_commands" {
  description = "Commands to run after SSH'ing into the instance"
  value       = <<-EOF
    # After connecting via SSH, run these commands:
    
    # Install Modular Platform
    pip install modular --index-url https://dl.modular.com/public/nightly/python/simple/
    
    # Install additional ML frameworks
    pip install openai-whisper tinygrad
    
    # Create workspace
    mkdir -p ~/hackathon && cd ~/hackathon
    
    # Clone your hackathon repositories (replace with actual repos)
    # git clone <your-hackathon-repo>
    
    # Start MAX server for inference
    # max serve --model-path=modularai/Llama-3.1-8B-Instruct-GGUF
  EOF
}

output "instance_status" {
  description = "Instance provisioning status"
  value       = "Instance provisioned successfully! Use 'make ssh' to connect."
}

output "available_instance_types" {
  description = "Available Lambda Cloud instance types"
  value       = data.lambdalabs_instance_types.available
}

output "startup_script" {
  description = "Startup script for manual installation on the instance"
  value       = local.startup_script
}

output "project_tags" {
  description = "Common tags for project resources"
  value       = local.common_tags
}