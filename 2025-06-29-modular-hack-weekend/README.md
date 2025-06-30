# Modular AI Hackathon (June 27-29, 2025)

A comprehensive project focusing on Modular AI Platform technologies, MAX inference optimization, Mojo programming, and cloud GPU infrastructure for high-performance AI workloads.

**🏠 [← Back to Hackathons Repository](../README.md)** • **[⚙️ Development Guide](./CLAUDE.md)** • **[🔧 GitHub Actions Setup](../.github/README.md)**

---

## 🎯 Project Overview

This hackathon explores the integration of cutting-edge AI infrastructure technologies:

### Core Technologies

- **[Modular Platform](../fork-modular/)**: High-performance AI inference with MAX engine
- **[Mojo Programming Language](../fork-modular/mojo/)**: Systems programming optimized for AI workloads
- **[OpenAI Whisper](../fork-openai-whisper/)**: Automatic speech recognition system
- **[TinyGrad Framework](../fork-tinygrad/)**: Lightweight deep learning framework
- **Lambda Cloud**: GPU infrastructure (A10, A100, H100 instances)
- **Terraform**: Infrastructure as code with Terraform Cloud backend

### Architecture Focus

- **Multi-modal AI pipelines**: Speech → Text → Inference workflows
- **Cloud-first GPU execution**: All computations on Lambda Cloud infrastructure
- **Performance optimization**: Mojo kernels optimized for cloud GPU hardware
- **Cost efficiency**: Automated resource lifecycle management

---

## 🚀 Quick Start

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

### Quick Commands Reference

```bash
make help                    # Show all available commands
make cloud-setup            # Initial Terraform Cloud setup
make plan apply             # Deploy GPU infrastructure
make status                 # Check instance status
make ssh                    # Connect to GPU instance
make outputs                # Show connection details
make destroy                # Clean up all resources
```

---

## 🛠️ Technology Stack

### Infrastructure & Cloud

- **Cloud GPUs**: Lambda Cloud (A10, A100, H100 instances)
- **Infrastructure as Code**: Terraform with Terraform Cloud backend
- **Provider**: [terraform-provider-lambdalabs](../terraform-provider-lambdalabs/)
- **CI/CD**: GitHub Actions with plan-first workflows
- **Cost Management**: Automated resource lifecycle management

### AI/ML Frameworks

- **Modular Platform**: High-performance AI inference with MAX
- **Mojo**: Systems programming language for AI workloads
- **OpenAI Whisper**: Automatic speech recognition
- **TinyGrad**: Lightweight deep learning framework

### Development Environment

- **Build System**: Bazel (via MODULE.bazel)
- **Environment Management**: Pixi for Python dependencies
- **Editor**: VS Code with multi-root workspace support
- **Version Control**: Git with project-specific branching

---

## 💰 Cost Management

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

## 🔧 Development Workflow

### Multi-Project Development

This project integrates with several external repositories in a coordinated workspace:

#### Cross-Repository Integration

1. **Data Flow**: Audio → Whisper (cloud GPU) → Text → MAX/Mojo processing (cloud GPU)
2. **Infrastructure**: terraform-provider-lambda manages cloud.lambda.ai GPU resources
3. **Performance Layer**: Mojo kernels optimized for cloud.lambda.ai GPU hardware
4. **Training Pipeline**: TinyGrad distributed across provisioned GPU instances

#### Workspace Integration

The VS Code workspace (`modular-hackathon.code-workspace`) includes:

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

### Essential Commands from Referenced Projects

#### Modular Platform (fork-modular)

```bash
# Build with Bazel wrapper
cd ../fork-modular
./bazelw build //...
./bazelw test //...

# MAX server operations
pip install modular --index-url https://dl.modular.com/public/nightly/python/simple/
max serve --model-path=modularai/Llama-3.1-8B-Instruct-GGUF

# Mojo development with Pixi
cd ../fork-modular/mojo
pixi install
pixi run mojo format ./
pixi run test
```

#### OpenAI Whisper Integration

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

## 🏗️ Infrastructure Details

### Terraform Configuration

- **Remote State**: Managed in Terraform Cloud workspace `modular-hackathon-jun-2025`
- **Provider**: `elct9620/lambdalabs` for Lambda Cloud resources
- **Organization**: Infrastructure organized in modular `.tf` files

### Terraform Files Structure

```text
infrastructure/
├── main.tf                  # Entry point and documentation
├── providers.tf             # Terraform Cloud + Lambda provider config
├── variables.tf             # Input variables with validation
├── data.tf                 # Data sources for external information
├── locals.tf               # Local values and computed expressions
├── resources.tf            # Infrastructure resources (instances, SSH keys)
├── outputs.tf              # Output values for post-deployment use
└── terraform.tfvars.example # Example configuration file
```

### CI/CD Integration

- **GitHub Actions**: Automated Terraform validation and deployment
- **Plan-first workflows**: All infrastructure changes reviewed before deployment
- **Security scanning**: TFLint and format checking on all Terraform files
- **Manual approval gates**: Production deployments require explicit approval

---

## 🔒 Security & Best Practices

### Credential Management

- **Environment Variables**: Store API keys securely
- **No Secrets in Git**: Use .gitignore and environment files
- **Access Controls**: Limit cloud resource permissions
- **Monitoring**: Track resource usage and access

### Development Security

```bash
# Required environment variables
export LAMBDALABS_API_KEY="your-lambda-cloud-api-key"
export TF_TOKEN_app_terraform_io="your-terraform-cloud-token"

# Never commit these to version control!
# They're protected by .gitignore patterns
```

### Infrastructure Security

- **SSH Key Management**: Automated SSH key provisioning and cleanup
- **Network Security**: Proper firewall rules for cloud instances
- **Resource Tagging**: Clear identification of resources for cost tracking
- **State Security**: Remote state in Terraform Cloud with encryption

---

## 🔗 Related Resources

### Documentation Links

- **[Modular Platform Documentation](https://docs.modular.com/)**
- **[Lambda Cloud Documentation](https://docs.lambdalabs.com/)**
- **[Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)**
- **[TFLint Documentation](https://github.com/terraform-linters/tflint)**

### Repository Links

- **[🏠 Hackathons Mono Repo](../README.md)**: Main repository overview
- **[🤖 Claude Development Guide](./CLAUDE.md)**: Detailed development guidance
- **[🔧 GitHub Actions Setup](../.github/README.md)**: CI/CD configuration guide
- **[🛠️ Infrastructure Code](./infrastructure/)**: Terraform configuration files

### External Integrations

- **[fork-modular](../fork-modular/)**: Modular Platform with MAX and Mojo
- **[fork-openai-whisper](../fork-openai-whisper/)**: Speech recognition system
- **[terraform-provider-lambdalabs](../terraform-provider-lambdalabs/)**: Infrastructure provider
- **[fork-tinygrad](../fork-tinygrad/)**: Deep learning framework

---

## 🆘 Troubleshooting

### Common Issues

#### Infrastructure Problems

```bash
# Check Terraform Cloud authentication
make cloud-status

# Reset authentication if needed
make cloud-fix-auth

# Monitor instance provisioning
make watch-status

# Get detailed instance information
make status
```

#### Connection Issues

```bash
# Verify instance is running
make status

# Get SSH connection details
make outputs

# Manual SSH command
ssh -i ~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key ubuntu@$(terraform output -raw instance_ip)
```

#### Cost Control

```bash
# Emergency resource cleanup
make emergency-stop

# Verify all resources destroyed
make status

# Check Lambda Cloud dashboard for remaining resources
```

### Getting Help

1. **Check Project Documentation**: This README and [CLAUDE.md](./CLAUDE.md)
2. **Infrastructure Issues**: Use `make status` and cloud provider consoles
3. **Cost Issues**: Monitor cloud billing and destroy unused resources
4. **Development Issues**: Refer to CLAUDE.md for debugging guidance

### Emergency Procedures

- **Resource Cleanup**: `make emergency-stop` (immediate destruction)
- **Access Issues**: Check API keys and cloud credentials
- **Cost Overruns**: Immediately destroy all resources: `make destroy`

---

**🚀 Ready to build?** Start with `make help` to see all available commands!

**💡 Need specific guidance?** Check the [development guide](./CLAUDE.md) for detailed patterns and workflows!

**🔧 Infrastructure questions?** Review the [GitHub Actions setup](../.github/README.md) for CI/CD details!
