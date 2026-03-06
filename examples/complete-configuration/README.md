# Complete Configuration Example

This example demonstrates comprehensive customization of the Kubernetes Gateway API module, showing how to configure all available options explicitly for fine-grained control over the deployment.

## Overview

This example provides a complete, production-ready configuration of the Gateway API module with explicit values for every available parameter. It's useful for environments where you need precise control over versions and deployment settings.

## Configuration Options

This example demonstrates all configuration possibilities:

| Option | Value | Description |
|--------|-------|-------------|
| **Module Source** | `tf-kubernetes-iaac/api/gateway` | Registry module source |
| **Module Version** | `1.0.0` | Module version tag |
| **Helm Release Name** | `custom-gateway-api` | Custom name for the Helm release |
| **Chart Version** | `0.2.0` | Specific version of the Helm chart |
| **Gateway API Version** | `1.5.0` | Specific version of Gateway API CRDs |
| **Channel** | `standard` | Stable release channel |

## Prerequisites

- Terraform 1.3 or later
- A running, accessible Kubernetes cluster
- `kubectl` configured with appropriate cluster access
- Helm 3.x installed
- Sufficient RBAC permissions to create cluster-scoped resources

## Usage

### Step 1: Navigate to the Example Directory

```bash
cd examples/complete-configuration
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Customize Configuration (Optional)

Edit `main.tf` to modify any of the module parameters:

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "my-custom-gateway"  # Change this
  chart_version     = "0.3.0"              # Update to newer version
  gateway_version   = "1.6.0"              # Update API version
  channel           = "experimental"       # Change to experimental
}
```

**Available Channel Values**:
- `"standard"`: Stable, production-ready releases (default)
- `"experimental"`: Latest features and experimental releases

### Step 4: Plan the Deployment

```bash
terraform plan
```

Review the output to understand exactly what will be deployed.

### Step 5: Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Step 6: Verify the Deployment

Use the provided outputs and verification commands:

```bash
# Show terraform outputs
terraform output
```

Or manually verify:

```bash
# List Helm releases
helm list

# Check Gateway API CRDs
kubectl get crds | grep gateway

# List all Gateway API resources
kubectl api-resources | grep gateway

# Check for any pods deployed by Gateway API
kubectl get pods --all-namespaces -l app.kubernetes.io/name=gateway-api
```

## Module Parameters Explained

### helm_release_name
- **Type**: String
- **Default**: `""` (auto-generates to `helm-gateway-api-release`)
- **Purpose**: Identifies the Helm release in your cluster
- **Tip**: Use descriptive names for easy identification

### chart_version
- **Type**: String
- **Default**: `0.2.0`
- **Purpose**: Controls which version of the Helm chart is used
- **Note**: Must be compatible with the specified `gateway_version`

### gateway_version
- **Type**: String
- **Default**: `1.5.0`
- **Purpose**: Specifies which version of the Gateway API CRDs to install
- **Version Compatibility**: 
  - v1.0.0+: Core Gateway resources
  - v1.1.0+: Enhanced routing capabilities
  - v1.5.0+: Extended resource types
  - v1.6.0+: Latest features and improvements

### channel
- **Type**: String
- **Default**: `"standard"`
- **Options**: `"standard"` or `"experimental"`
- **Purpose**: Determines which release channel to use
- **Recommendation**: Use `"standard"` for production environments

## Working with Configuration

### Updating Versions

To update to newer versions of Gateway API:

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "custom-gateway-api"
  chart_version     = "0.3.0"      # Updated
  gateway_version   = "1.6.0"      # Updated
  channel           = "standard"
}
```

Then apply:

```bash
terraform plan
terraform apply
```

### Switching to Experimental Channel

For testing cutting-edge features:

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "custom-gateway-api"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "experimental"  # Changed
}
```

## Terraform Outputs

This configuration provides several useful outputs:

### release_name
The name of the deployed Helm release, useful for managing the release with Helm CLI.

### chart_version
The version of the Helm chart that was deployed.

### gateway_api_version
The version of the Gateway API CRDs that were installed.

### installation_channel
The deployment channel used (standard or experimental).

### deployment_instructions
Quick reference commands for verifying the deployment.

## Advanced Usage

### Multi-Environment Setup

Create separate configurations for different environments:

```bash
# Development - with experimental features
# complete-configuration/dev.tfvars
helm_release_name = "gateway-api-dev"
gateway_version   = "1.6.0"
channel           = "experimental"

# Production - stable versions
# complete-configuration/prod.tfvars
helm_release_name = "gateway-api-prod"
gateway_version   = "1.5.0"
channel           = "standard"
```

Apply for specific environment:

```bash
terraform apply -var-file="dev.tfvars"
```

### Managing Multiple Releases

Deploy multiple instances with different names:

```hcl
module "gateway_api_primary" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-primary"
  gateway_version   = "1.5.0"
}

module "gateway_api_secondary" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-secondary"
  gateway_version   = "1.6.0"
}
```

## Troubleshooting

### Issue: Chart Not Found

**Error**: `Error: failed to download "oci://ghcr.io/nicklasfrahm/charts/gateway-api"`

**Solution**: Ensure OCI support and credentials:

```bash
# Update Helm
helm repo update

# Verify OCI access (if needed)
helm registry login ghcr.io
```

### Issue: CRD Installation Fails

**Error**: `Error: unable to create CRD`

**Solution**: Check RBAC permissions:

```bash
# Verify permissions
kubectl auth can-i create customresourcedefinitions
```

### Issue: Version Incompatibility

**Error**: `Error: chart version X requires gateway version Y`

**Solution**: Check compatibility matrix and use compatible versions. Update both values together.

### Issue: Release Already Exists

**Error**: `Error: release name already exists`

**Solution**: Use a different `helm_release_name` or destroy the existing release:

```bash
terraform destroy
```

## Managing the Deployment

### Viewing Helm Release Details

```bash
# Get the specific release
helm get values custom-gateway-api

# Get all release details
helm get all custom-gateway-api

# View release history
helm history custom-gateway-api
```

### Upgrading the Release

Modify the configuration and run:

```bash
terraform plan  # Review changes
terraform apply # Apply updates
```

### Rolling Back

To rollback to a previous version:

```bash
# Get the revision number
helm history custom-gateway-api

# Rollback
helm rollback custom-gateway-api <revision>
```

## Cleanup

Remove all deployed resources:

```bash
terraform destroy
```

When prompted, type `yes` to confirm deletion.

## Related Examples

- **[Basic Configuration](../basic-configuration/)**: Minimal setup with defaults
- **[Custom Versions](../custom-versions/)**: Focus on version management

## Additional Resources

- [Gateway API Official Documentation](https://gateway-api.sigs.k8s.io/)
- [nicklasfrahm/charts Repository](https://github.com/nicklasfrahm/charts)
- [Kubernetes Gateway API Concepts](https://gateway-api.sigs.k8s.io/concepts/api-overview/)
- [Helm Chart Repository](https://helm.sh/docs/helm_package_manager/repository/)
- [Terraform Helm Provider Reference](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)

## Best Practices

1. **Version Control**: Keep track of configuration changes
2. **Documentation**: Document why specific versions are chosen
3. **Testing**: Test in non-production environments first
4. **Monitoring**: Monitor Gateway API pod status after deployment
5. **Backups**: Consider backing up your kubeconfig and Terraform state

## Support

For issues or questions about this configuration:

1. Check the [Gateway API documentation](https://gateway-api.sigs.k8s.io/)
2. Review [Terraform Helm provider docs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
3. Check Kubernetes cluster logs: `kubectl logs -n <namespace>`
