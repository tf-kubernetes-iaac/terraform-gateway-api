# Gateway API Terraform Module - Examples

This directory contains comprehensive examples demonstrating different ways to use and configure the terraform-gateway-api module.

## Examples Overview

| Example | Complexity | Use Case |
|---------|-----------|----------|
| [Basic Configuration](#basic-configuration) | ⭐ Beginner | Get started quickly with defaults |
| [Complete Configuration](#complete-configuration) | ⭐⭐ Intermediate | Full customization of all options |
| [Custom Versions](#custom-versions) | ⭐⭐ Intermediate | Version management and upgrades |

## Quick Start

### Basic Configuration

Perfect for getting started with minimal configuration:

```bash
cd basic-configuration
terraform init
terraform plan
terraform apply
```

**What it does**: Deploys Gateway API with all default settings in just a few minutes.

**Best for**: Learning, development environments, quick prototypes.

[→ See Basic Configuration Example](./basic-configuration/README.md)

### Complete Configuration

Shows all available options with explicit values:

```bash
cd complete-configuration
terraform init
terraform plan
terraform apply
```

**What it does**: Deployments with full control over release names, versions, and channels.

**Best for**: Production environments, custom deployments, documentation.

[→ See Complete Configuration Example](./complete-configuration/README.md)

### Custom Versions

Demonstrates version management strategies:

```bash
cd custom-versions
terraform init
terraform plan
terraform apply
```

**What it does**: Shows how to deploy specific versions, test multiple versions, and manage upgrades.

**Best for**: Version control, testing new releases, gradual migrations.

[→ See Custom Versions Example](./custom-versions/README.md)

## Common Tasks

### Deploy Gateway API

```bash
cd basic-configuration
terraform init
terraform apply
```

### Deploy with Custom Name

```bash
cd complete-configuration
# Edit main.tf and change helm_release_name
terraform apply
```

### Update Gateway API Version

```bash
cd custom-versions
# Edit main.tf to update gateway_version
terraform plan
terraform apply
```

### Clean Up

```bash
# From any example directory
terraform destroy
```

## Project Structure

```
examples/
├── basic-configuration/
│   ├── README.md           # Detailed guide
│   └── main.tf             # Terraform configuration
├── complete-configuration/
│   ├── README.md           # Detailed guide
│   └── main.tf             # Terraform configuration
└── custom-versions/
    ├── README.md           # Detailed guide
    └── main.tf             # Terraform configuration
```

## Prerequisites for All Examples

Ensure you have:

- ✅ Terraform 1.3 or later
- ✅ Kubernetes cluster (local or remote)
- ✅ kubectl configured to access your cluster
- ✅ Helm client configured
- ✅ Proper kubeconfig file
- ✅ RBAC permissions for CRD installation

### Verify Prerequisites

```bash
# Check Terraform version
terraform version

# Check Kubernetes access
kubectl cluster-info

# Check Helm configuration
helm version

# Verify kubeconfig
cat ~/.kube/config | head -n 5
```

## Common Troubleshooting

### Terraform Commands Not Found

```bash
# Install Terraform
brew install terraform  # macOS
# or download from https://www.terraform.io/downloads

# Verify installation
terraform version
```

### Cannot Access Kubernetes Cluster

```bash
# Verify kubeconfig
export KUBECONFIG=~/.kube/config
kubectl get nodes

# Switch context if needed
kubectl config use-context <cluster-name>
```

### Helm Provider Issues

```bash
# Update Helm
brew upgrade helm  # macOS
helm repo update

# Test Helm access
helm list
```

### Provider Configuration Issues

```bash
# Reinitialize Terraform
terraform init -upgrade

# Clean and reinitialize
rm -rf .terraform
terraform init
```

## Example Commands Reference

### Initialize (Required First Time)

```bash
terraform init
```

### Plan (Review Changes)

```bash
terraform plan
```

### Apply (Deploy)

```bash
terraform apply
```

### Show (View Current State)

```bash
terraform show
```

### Destroy (Clean Up)

```bash
terraform destroy
```

### Validate Configuration

```bash
terraform validate
```

### Format Code

```bash
terraform fmt
```

## Environment Variables

Set these for custom Kubernetes environments:

```bash
# Use specific kubeconfig
export KUBECONFIG=/path/to/kubeconfig

# Use specific context
export KUBE_CTX=my-cluster

# Debug Terraform
export TF_LOG=DEBUG
```

## Verifying Deployments

After applying any example, verify success:

```bash
# Check Helm release exists
helm list

# Verify Gateway API CRDs
kubectl get crds | grep gateway

# List Gateway resources
kubectl api-resources | grep gateway.networking

# Check for pods
kubectl get pods --all-namespaces -l app.kubernetes.io/name=gateway-api
```

## Comparing Examples

### When to Use Each

**Basic Configuration**:
- ✅ First time learning
- ✅ Development environment
- ✅ Quick testing
- ✅ Default settings sufficient
- ❌ Not for production typically

**Complete Configuration**:
- ✅ Production deployment
- ✅ Custom release names needed
- ✅ Specific versions required
- ✅ Need explicit configuration
- ✅ Compliance/documentation

**Custom Versions**:
- ✅ Managing multiple versions
- ✅ Testing upgrades
- ✅ Gradual migrations
- ✅ Version compatibility testing
- ✅ Side-by-side deployments

## Module Variables Reference

All examples use the following module source and version:

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  # Input variables
  helm_release_name = "gateway-api"   # Release identifier
  chart_version     = "0.2.0"        # Helm chart version
  gateway_version   = "1.5.0"        # Gateway API CRDs version
  channel           = "standard"      # Release channel
}

## State Management

Terraform maintains state files in each example directory:

```bash
# View current state
terraform state list
terraform state show

# Backup state
cp terraform.tfstate terraform.tfstate.backup

# Remove resource from state (careful!)
terraform state rm module.gateway_api
```

⚠️ **Warning**: Don't share state files with sensitive information. Use remote state backends for production.

## Working with Multiple Environments

Create environment-specific configurations:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Staging
terraform apply -var-file="staging.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

Example `prod.tfvars`:
```hcl
helm_release_name = "gateway-api-prod"
gateway_version   = "1.5.0"  # Stable version
channel           = "standard"
```

## Resources

- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [nicklasfrahm/charts](https://github.com/nicklasfrahm/charts)

## Getting Help

1. **Read Example READMEs**: Each example has detailed documentation
2. **Check Error Messages**: Terraform provides helpful error details
3. **Review Main Module**: See [../README.md](../README.md) for module documentation
4. **Kubectl Debugging**: Use `kubectl describe` to investigate issues

## Next Steps

1. ✅ Read the main [module README](../README.md)
2. ✅ Choose appropriate example
3. ✅ Follow the example's README guide
4. ✅ Deploy to your environment
5. ✅ Explore Gateway API resources

## Keeping Examples Updated

These examples use latest versions. Updates may be needed when:

- New Terraform provider versions are released
- New Gateway API versions are available
- Module interfaces change
- Best practices evolve

Check GitHub or the main module README for updates.

## Contributing

If you have improvements to these examples:

1. Test thoroughly
2. Update documentation
3. Verify all examples still work
4. Submit feedback

## License

These examples are provided as-is for learning and development purposes.

---

Ready to get started? Pick an example above and follow its README!
