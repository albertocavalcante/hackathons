# CLAUDE.md - Modular AI Hackathon (June 29, 2025)

This file provides guidance to Claude Code (claude.ai/code) when working with this specific hackathon project within the hackathons mono repository.

**🏠 [← Hackathons Repository](../README.md)** • **[📖 Project README](./README.md)** • **[🤖 Mono Repo Guidance](../CLAUDE.md)** • **[🔧 CI/CD Setup](../.github/README.md)**

**📁 Project Location**: `hackathons/2025-06-29-modular-hack-weekend/`  
**⚠️ Working Directory**: All commands in this file assume you're in this project directory

## Project Overview

This hackathon project focuses on Modular AI technologies, specifically designed for the June 29, 2025 modular hackathon weekend. The project serves as a specialized workspace that integrates knowledge and components from multiple related projects:

- **fork-modular**: Modular Platform with MAX inference server and Mojo programming language
- **fork-openai-whisper**: OpenAI's automatic speech recognition system
- **terraform-provider-lambda**: Terraform provider for cloud.lambda.ai GPU infrastructure
- **fork-tinygrad**: Deep learning framework

**Important**: All GPU computations must run on **cloud.lambda.ai** infrastructure. The terraform-provider-lambda handles provisioning and managing these cloud GPU resources for the hackathon workloads.

## Workspace Structure

This project is part of a mono repository structure. The VS Code workspace (`modular-hackathon.code-workspace`) includes:

```text
hackathons/                                    # Mono repo root
├── MODULE.bazel                               # Bazel workspace configuration
├── CLAUDE.md                                  # General mono repo guidance
├── README.md                                  # Mono repo documentation
├── 2025-06-29-modular-hack-weekend/          # This hackathon project
│   ├── CLAUDE.md                              # This file - project-specific guidance
│   ├── README.md                              # Project documentation
│   ├── Makefile                               # Project automation (Terraform)
│   ├── infrastructure/                        # Terraform infrastructure code
│   │   ├── *.tf files                         # Organized Terraform configuration
│   │   └── .gitignore                         # Infrastructure-specific gitignore
│   └── modular-hackathon.code-workspace       # VS Code workspace for this project
├── ../fork-modular/                           # Modular Platform (MAX + Mojo)
├── ../fork-openai-whisper/                    # Speech recognition system
├── ../terraform-provider-lambda/              # Infrastructure provider
└── ../fork-tinygrad/                          # Deep learning framework
```

## Essential Commands from Referenced Projects

### Modular Platform (fork-modular)

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

### Mojo Standard Library Development

```bash
# Build standard library
cd ../fork-modular/mojo
./stdlib/scripts/build-stdlib.sh
./stdlib/scripts/run-tests.sh

# Use locally built stdlib
MODULAR_MOJO_MAX_IMPORT_PATH=../build mojo main.mojo
```

### OpenAI Whisper Integration

```bash
cd ../fork-openai-whisper
pip install -e .
python -m pytest tests/
```

### TinyGrad Framework

```bash
cd ../fork-tinygrad
python -m pytest test/
python examples/mnist.py
```

### Cloud GPU Infrastructure (terraform-provider-lambda)

```bash
cd ../terraform-provider-lambda
go mod download
go build

# Configure cloud.lambda.ai credentials
export LAMBDA_CLOUD_API_KEY="your-api-key"

# Initialize and provision GPU resources
terraform init
terraform plan
terraform apply

# Example: Deploy GPU instances for MAX inference
terraform apply -var="instance_type=gpu_1x_a100" -var="region=us-west-2"
```

## High-Level Architecture Patterns

### Multi-Modal AI Pipeline Architecture

Based on the workspace components, typical hackathon projects involve cloud.lambda.ai GPU execution:

1. **Speech Processing**: Whisper for audio transcription (CPU/GPU via cloud.lambda.ai)
2. **Inference Optimization**: MAX/Mojo for high-performance model serving on cloud GPUs
3. **Infrastructure**: Terraform manages cloud.lambda.ai GPU resources and deployment
4. **Model Training**: TinyGrad for lightweight ML operations on provisioned GPU instances

### Cloud GPU Execution Flow

```
Local Development → Terraform Provision → cloud.lambda.ai GPU → MAX/Mojo Inference
  ↓                        ↓                    ↓                    ↓
Whisper        →    GPU Instance Setup   →   Model Loading    →   Results
```

### Cross-Project Integration Points

- **Data Flow**: Audio → Whisper (cloud GPU) → Text → MAX/Mojo processing (cloud GPU)
- **Infrastructure**: terraform-provider-lambda manages cloud.lambda.ai GPU resources
- **Performance Layer**: Mojo kernels optimized for cloud.lambda.ai GPU hardware
- **Training Pipeline**: TinyGrad distributed across provisioned GPU instances
- **Resource Management**: Automatic scaling and teardown of cloud GPU resources

## Development Workflow

### Hackathon-Specific Patterns

1. **Cross-Repository Development**: Work across multiple forked projects simultaneously
2. **Cloud-First GPU Development**: All GPU workloads target cloud.lambda.ai infrastructure
3. **Rapid Prototyping**: Leverage existing components from mature projects
4. **Infrastructure-as-Code**: Use terraform-provider-lambda for GPU resource management
5. **Integration Focus**: Emphasis on connecting different AI/ML tools via cloud APIs
6. **Performance Optimization**: Use Mojo/MAX for production-grade inference on cloud GPUs

### Git Workflow

```bash
# Navigate to this project directory (from mono repo root)
cd 2025-06-29-modular-hack-weekend

# Work on hackathon branch
git checkout modular-hackathon-jun-2025

# Coordinate changes across workspace
# Changes to fork-* directories should be committed to their respective repos
# Integration code goes in this hackathon project directory

# Project-specific infrastructure automation
make cloud-setup plan apply  # From this directory
```

### Testing Integration Components

```bash
# Test components independently first
cd ../fork-modular && ./bazelw test //...
cd ../fork-openai-whisper && python -m pytest
cd ../fork-tinygrad && python -m pytest test/
cd ../terraform-provider-lambda && go test ./...

# Test cloud.lambda.ai infrastructure
cd ../terraform-provider-lambda
terraform plan -var="instance_type=gpu_1x_a10" # Validate config
terraform apply -auto-approve # Deploy test environment
terraform destroy -auto-approve # Clean up resources

# Test GPU workloads on cloud.lambda.ai
# (Add specific cloud GPU test commands as project develops)
```

## Performance Considerations

### Leveraging Modular Platform Optimizations on cloud.lambda.ai

- Use Mojo kernels optimized for cloud.lambda.ai GPU hardware (A100, H100)
- Leverage MAX for optimized model serving on cloud GPU instances
- Consider cloud.lambda.ai specific optimizations (memory bandwidth, compute capability)
- Use Pixi environments for consistent dependency management across local and cloud

### Memory and Compute Efficiency for Cloud GPUs

- Follow Mojo value semantics and ownership patterns
- Minimize CPU-GPU synchronization points on cloud instances
- Use efficient data formats between pipeline stages
- Optimize for cloud.lambda.ai GPU memory constraints
- Consider batch processing for throughput optimization on cloud hardware
- Implement auto-scaling based on GPU utilization metrics

## Critical Development Notes

### Mojo/MAX Integration

- Use nightly builds for development
- Follow atomic commit practices with proper tagging (`[Kernels]`, `[Stdlib]`)
- Wrap commits with `BEGIN_PUBLIC`/`END_PUBLIC` markers
- Sign commits with `git commit -s`

### Multi-Project Coordination

- Changes to fork-* projects should align with upstream contribution guidelines
- Integration code belongs in this hackathon repository
- Document cross-project dependencies clearly
- Test integration points thoroughly
- **GPU Resource Management**: Always use terraform-provider-lambda for cloud.lambda.ai provisioning
- **Cost Optimization**: Implement proper resource cleanup to avoid unnecessary cloud charges

### Platform Support

- **Local Development**: Linux x86_64/aarch64 and macOS ARM64
- **GPU Execution**: cloud.lambda.ai (NVIDIA A100, H100, A10 instances)
- **Container Deployments**: MAX containers available for cloud.lambda.ai deployment
- Windows support varies by component (not recommended for hackathon)

## Environment Setup

### Prerequisites

```bash
# Install Pixi for environment management
curl -fsSL https://pixi.sh/install.sh | bash

# Install Modular nightly
pip install modular --index-url https://dl.modular.com/public/nightly/python/simple/

# Install Terraform for cloud.lambda.ai management
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Set up cloud.lambda.ai credentials
export LAMBDA_CLOUD_API_KEY="your-api-key"

# Install other dependencies as needed per project
```

### Development Environment

- Use VS Code with the workspace file
- Install Mojo nightly VS Code extension
- Configure environment variables for cross-project imports
- Set up testing infrastructure for integration components
- Configure cloud.lambda.ai credentials for GPU access
- Set up Terraform state management for cloud resources

## Contributing Guidelines

- Follow individual project contribution guidelines for fork-* directories
- Integration code in this repo should be well-documented
- Include benchmarks for performance-critical components
- Test across the full integration pipeline
- Document API interfaces between components

## Security Considerations

- Never commit secrets, API keys, or tokens (especially LAMBDA_CLOUD_API_KEY)
- Use environment variables or secure credential management for cloud.lambda.ai access
- Be mindful of model licensing when using pre-trained models
- Follow security best practices for cloud deployments
- Consider data privacy implications for speech processing pipelines
- Implement proper cloud resource tagging and access controls
- Monitor GPU usage and costs to prevent unexpected charges

## Documentation References

### Modular Platform Documentation

- **LLM-friendly docs**: <https://docs.modular.com/llms.txt>
- **Mojo API docs**: <https://docs.modular.com/llms-mojo.txt>  
- **Python API docs**: <https://docs.modular.com/llms-python.txt>
- **Comprehensive docs**: <https://docs.modular.com/llms-full.txt>

### Key Technical Areas from llms.txt

- MAX Python APIs for graph operations, neural networks, pipelines
- Mojo CLI tools for building, debugging, testing
- Hardware-agnostic custom operations and optimizations
- GPU programming abstractions and tensor memory management
- Specialized modules for convolutions, attention, KV caching, quantization
