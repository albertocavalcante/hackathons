# Lambda Cloud Infrastructure Variables
# Modular Hackathon - June 2025

variable "lambda_api_key" {
  description = "Lambda Cloud API key"
  type        = string
  sensitive   = true
  default     = null # Will use LAMBDALABS_API_KEY env var if not provided
}

variable "instance_type" {
  description = "Lambda Cloud instance type"
  type        = string
  default     = "gpu_1x_a10" # A10 GPU at $0.75/hour, more available

  validation {
    condition = contains([
      "gpu_1x_rtx6000",
      "gpu_1x_a10",
      "gpu_1x_v100",
      "gpu_1x_a100",
      "gpu_2x_a100",
      "gpu_4x_a100",
      "gpu_8x_a100"
    ], var.instance_type)
    error_message = "Instance type must be a valid Lambda Cloud GPU instance type."
  }
}

variable "region" {
  description = "Lambda Cloud region"
  type        = string
  default     = "us-east-1" # Try different region for better availability

  validation {
    condition = contains([
      "us-east-1",
      "us-west-1",
      "us-west-2",
      "us-midwest-1",
      "asia-pacific-1",
      "europe-central-1"
    ], var.region)
    error_message = "Region must be a valid Lambda Cloud region."
  }
}

variable "ssh_key_name" {
  description = "Name of SSH key registered in Lambda Cloud"
  type        = string
  default     = "hackathon-key"

  validation {
    condition     = length(var.ssh_key_name) > 0
    error_message = "SSH key name cannot be empty."
  }
}

variable "ssh_public_key" {
  description = "SSH public key content for Lambda Cloud access"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvw7ID1or4Va8cs57Og7BvJ2fc5TyaBwiIpRBuirqv7 modular-hackathon-jun-2025@lambdalabs"

  validation {
    condition     = length(var.ssh_public_key) > 0
    error_message = "SSH public key cannot be empty."
  }
}

variable "instance_name" {
  description = "Name for the GPU instance"
  type        = string
  default     = "modular-hackathon-gpu-jun2025"

  validation {
    condition     = length(var.instance_name) > 0 && length(var.instance_name) <= 63
    error_message = "Instance name must be between 1 and 63 characters."
  }
}

variable "enable_file_system" {
  description = "Whether to attach a file system for persistent storage"
  type        = bool
  default     = false
}

variable "file_system_names" {
  description = "List of file system names to attach to the instance"
  type        = list(string)
  default     = []
}
