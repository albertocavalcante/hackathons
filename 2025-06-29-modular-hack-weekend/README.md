# Modular AI Hackathon (June 27-29, 2025)

A comprehensive project focusing on Modular AI Platform technologies, MAX inference optimization, Mojo programming, and cloud GPU infrastructure for high-performance AI workloads.

**[← Back to Hackathons Repository](../README.md)** • **[Development Guide](./CLAUDE.md)**

---

## Project Overview

This hackathon explores the integration of cutting-edge AI infrastructure technologies:

### Core Technologies

- **Modular Platform**: High-performance AI inference with MAX engine
- **Mojo Programming Language**: Systems programming optimized for AI workloads  
- **OpenAI Whisper**: Automatic speech recognition system
- **TinyGrad Framework**: Lightweight deep learning framework
- **Lambda Cloud**: GPU infrastructure (A10, A100, H100 instances)
- **Terraform**: Infrastructure as code with Terraform Cloud backend

### Architecture Focus

- **Multi-modal AI pipelines**: Speech → Text → Inference workflows
- **Cloud-first GPU execution**: All computations on Lambda Cloud infrastructure
- **Performance optimization**: Mojo kernels optimized for cloud GPU hardware
- **Cost efficiency**: Automated resource lifecycle management

---

## Quick Start

### Prerequisites

1. **Development Tools**:
  ```bash
  # Install required tools
  brew install terraform git
  curl -fsSL https://pixi.sh/install.sh | bash
  ```

2. **Cloud Access**:
  - [Lambda Cloud account](https://lambdalabs.com/service/gpu-cloud) and API key
  - [Terraform Cloud account](https://app.terraform.io/) for remote state management

3. **VS Code Setup**:
  - Install VS Code and open workspace: `modular-hackathon.code-workspace`

### Infrastructure Setup

```bash
# Navigate to project directory
cd 2025-06-29-modular-hack-weekend

# See all available commands
make help

# Set up Terraform Cloud authentication
make cloud-setup

# Plan and deploy GPU infrastructure
make plan apply

# Monitor deployment progress
make watch-status

# Connect to GPU instance
make ssh

# When finished, clean up resources
make destroy
```

### Essential Commands

```bash
make help                    # Show all available commands
make cloud-setup            # Initial Terraform Cloud setup
make plan apply             # Deploy GPU infrastructure
make status                 # Check instance status
make ssh                    # Connect to GPU instance
make outputs                # Show connection details
make destroy                # Clean up all resources
make emergency-stop         # Immediate resource destruction
```

---

## Infrastructure & CI/CD

### Terraform Configuration

The infrastructure is organized in modular Terraform files:

```text
infrastructure/
├── main.tf                 # Entry point and documentation
├── providers.tf            # Terraform Cloud + Lambda provider config
├── variables.tf            # Input variables with validation
├── data.tf                # Data sources (SSH keys, instance types)
├── locals.tf              # Local values and computed expressions  
├── resources.tf           # Infrastructure resources (instances, SSH keys)
├── outputs.tf             # Output values for connection details
└── terraform.tfvars.example # Example configuration file
```

**Configuration**:
- **Remote State**: Managed in Terraform Cloud workspace `modular-hackathon-jun-2025`
- **Provider**: `elct9620/lambdalabs` for Lambda Cloud resources
- **Organization**: `alberto` (automatically configured)

### GitHub Actions Workflows

The repository includes comprehensive CI/CD automation:

#### 1. Terraform Validation (`terraform-validation.yml`)
**Triggers**: Pull requests and pushes affecting `*.tf` files
**Actions**:
- Format checking with `terraform fmt`
- Configuration validation with `terraform validate`
- Security scanning with TFLint (comprehensive rules + cloud provider plugins)
- Configuration scanning with Trivy
- Sensitive data detection
- File naming convention checks

#### 2. Terraform Plan (`terraform-plan.yml`)
**Triggers**: Manual workflow dispatch
**Actions**:
- Generate execution plan
- Post plan as PR comment for review
- No automatic application

#### 3. Terraform Apply (`terraform-apply.yml`)
**Triggers**: Manual workflow dispatch with approval
**Actions**:
- Apply approved infrastructure changes
- Update infrastructure state
- Requires explicit manual trigger

#### 4. Terraform Destroy (`terraform-destroy.yml`)
**Triggers**: Manual workflow dispatch with confirmation
**Actions**:
- Destroy all infrastructure resources
- Clean up remote state
- Requires explicit confirmation

### Security & Validation

**Automated Checks**:
- **TFLint**: Comprehensive Terraform best practices validation
- **Format Enforcement**: Consistent code formatting across all files
- **Security Scanning**: Trivy configuration scanning for misconfigurations
- **Secret Detection**: Automated detection of potential secrets in code
- **Provider Validation**: Ensure all required providers are properly configured

**Manual Gates**:
- Infrastructure changes require manual plan review
- Resource creation requires explicit apply trigger
- Resource destruction requires confirmation

---

## Cost Management

### GPU Instance Pricing (Lambda Cloud)

| Instance Type | GPU | VRAM | Price/Hour | Use Case |
|---------------|-----|------|------------|----------|
| **RTX 6000** | RTX 6000 | 24GB | **$0.50** | Development, testing |
| **A10** | A10 | 24GB | **$0.75** | Balanced performance |
| **A100** | A100 | 40GB | **$1.10** | High-performance inference |
| **A100 (80GB)** | A100 | 80GB | **$1.75** | Large model training |

### Cost Estimation

- **24-hour hackathon with RTX 6000**: ~$12
- **12-hour development session with A10**: ~$9
- **4-hour intensive compute with A100**: ~$4.40

### Best Practices

- **Always destroy resources** when not in use: `make destroy`
- **Monitor costs** via Lambda Cloud dashboard
- **Set up billing alerts** for cost control
- **Use cheapest instances** for development and testing

---

## Development Workflow

### Multi-Project Integration

This project coordinates with several external repositories through VS Code workspace:

```json
{
  "folders": [
    { "path": "./hackathons" },
    { "path": "../fork-modular" },
    { "path": "../fork-openai-whisper" },
    { "path": "../terraform-provider-lambda" },
    { "path": "../fork-tinygrad" }
  ]
}
```

### Essential Commands by Technology

#### Modular Platform
```bash
cd ../fork-modular
./bazelw build //...
pip install modular --index-url https://dl.modular.com/public/nightly/python/simple/
max serve --model-path=modularai/Llama-3.1-8B-Instruct-GGUF
```

#### Mojo Development
```bash
cd ../fork-modular/mojo
pixi install
pixi run mojo format ./
pixi run test
```

#### OpenAI Whisper
```bash
cd ../fork-openai-whisper
pip install -e .
python -m pytest tests/
```

#### TinyGrad Framework
```bash
cd ../fork-tinygrad
python -m pytest test/
python examples/mnist.py
```

---

## Security & Best Practices

### Credential Management

```bash
# Required environment variables
export LAMBDALABS_API_KEY="your-lambda-cloud-api-key"
export TF_TOKEN_app_terraform_io="your-terraform-cloud-token"

# Never commit these to version control!
```

### Infrastructure Security

- **SSH Key Management**: Automated SSH key provisioning and cleanup
- **Network Security**: Proper firewall rules for cloud instances  
- **Resource Tagging**: Clear identification for cost tracking
- **State Security**: Remote state in Terraform Cloud with encryption

---

## Troubleshooting

### Common Issues

#### Infrastructure Problems
```bash
# Check Terraform Cloud authentication
make cloud-status

# Reset authentication if needed
make cloud-fix-auth

# Monitor instance provisioning
make watch-status
```

#### Connection Issues
```bash
# Verify instance is running
make status

# Get SSH connection details
make outputs

# Manual SSH if needed
ssh -i ~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key ubuntu@$(terraform output -raw instance_ip)
```

#### Cost Control
```bash
# Emergency resource cleanup
make emergency-stop

# Verify all resources destroyed
make status
```

### Emergency Procedures

- **Resource Cleanup**: `make emergency-stop` (immediate destruction)
- **Access Issues**: Check API keys and cloud credentials
- **Cost Overruns**: Immediately destroy all resources: `make destroy`

---

## Related Resources

### Documentation
- **[Modular Platform Documentation](https://docs.modular.com/)**
- **[Lambda Cloud Documentation](https://docs.lambdalabs.com/)**
- **[Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)**

### Repository Links
- **[Hackathons Mono Repo](../README.md)**: Main repository overview
- **[Development Guide](./CLAUDE.md)**: Detailed development guidance
- **[Infrastructure Code](./infrastructure/)**: Terraform configuration files

---

**Ready to build?** Start with `make help` to see all available commands.
