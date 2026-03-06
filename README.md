# Terraform Kubernetes Gateway API Module

This Terraform module deploys the Kubernetes Gateway API using Helm. The Gateway API is a collection of resources that model service networking in Kubernetes. This module provides a simple way to install and configure the Gateway API in your Kubernetes cluster.

## Overview

The Gateway API significantly improves upon Ingress by giving more power to route and control traffic. It provides a more flexible, extensible, and role-oriented API for advanced traffic routing use cases.

## Features

- Deploy Kubernetes Gateway API using Helm charts
- Configurable chart version
- Configurable Gateway API version
- Support for different installation channels (standard, experimental)
- Customizable Helm release name
- Leverages the [nicklasfrahm/charts](https://github.com/nicklasfrahm/charts) Gateway API Helm chart

## Requirements

- Terraform >= 1.3
- Helm Provider >= 3.0.0
- Kubernetes cluster with Helm configured
- kubectl configured to access your cluster

## Providers

| Name | Version |
|------|---------|
| helm | ~> 3.0.0 |

## Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `helm_release_name` | The name of the Helm release | `string` | `""` (auto-generated as "helm-gateway-api-release") | no |
| `chart_version` | The version of the Gateway API Helm chart to deploy | `string` | `"0.2.0"` | no |
| `gateway_version` | The version of the Gateway API that you want to install | `string` | `"1.5.0"` | no |
| `channel` | The installation channel for Gateway API (standard or experimental) | `string` | `"standard"` | no |

## Module Outputs

| Name | Description | Type |
|------|-------------|------|
| `release_id` | The unique identifier of the Helm release | string |
| `release_name` | The name of the Helm release | string |
| `release_namespace` | The namespace where the Helm release is deployed | string |
| `release_status` | The status of the Helm release (e.g., deployed, pending) | string |
| `chart_version` | The version of the Helm chart deployed | string |
| `gateway_api_version` | The version of the Gateway API CRDs installed | string |
| `installation_channel` | The installation channel used (standard or experimental) | string |
| `chart_repository` | The OCI repository URL of the Gateway API Helm chart | string |
| `helm_release_attributes` | Complete Helm release attributes including all metadata | map |
| `verification_commands` | Useful kubectl and helm commands to verify the deployment | map |

### Output Examples

```hcl
# Access individual outputs
resource "local_file" "deployment_info" {
  filename = "${path.module}/deployment-info.txt"
  content = <<-EOT
    Release Name: ${module.gateway_api.release_name}
    Release ID: ${module.gateway_api.release_id}
    Status: ${module.gateway_api.release_status}
    Gateway API Version: ${module.gateway_api.gateway_api_version}
    Chart Version: ${module.gateway_api.chart_version}
    Channel: ${module.gateway_api.installation_channel}
  EOT
}

# Display verification commands
output "verify_deployment" {
  value = module.gateway_api.verification_commands
}
```

## Usage

### Basic Usage

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  # Uses default values
}
```

### Custom Configuration

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "my-gateway-api"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}
```

### Using Latest Versions

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  chart_version   = "0.3.0"  # Update to latest chart version
  gateway_version = "1.6.0"  # Update to latest Gateway API version
}
```

## How It Works

This module uses the Helm provider to deploy the Gateway API:

1. **Helm Chart Source**: Uses the OCI chart from `oci://ghcr.io/nicklasfrahm/charts/gateway-api`
2. **CRD Installation**: Deploys the Gateway API Custom Resource Definitions (CRDs) using the gatewayCRDInstaller
3. **Configurable Versions**: Allows you to specify exact versions for both the chart and the Gateway API components
4. **Channel Support**: Supports different installation channels for features or stability preferences

## Examples

This module includes several examples demonstrating different use cases:

- **[Basic Configuration](./examples/basic-configuration/)**: Minimal setup with default values
- **[Complete Configuration](./examples/complete-configuration/)**: Full configuration with all customizable options
- **[Custom Versions](./examples/custom-versions/)**: Deploying specific versions of Gateway API and chart

See the examples directory for detailed implementations.

## Prerequisites

Before using this module, ensure you have:

1. A running Kubernetes cluster
2. Helm 3.x installed and configured
3. Proper RBAC permissions to install cluster-scoped resources
4. Terraform 1.3 or later installed

### Kubernetes Provider Setup

This module requires the Helm provider to be configured. Here's an example:

```hcl
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    # Or use other authentication methods as needed
  }
}
```

## Installation Steps

1. **Prepare Your Terraform Configuration**:
   Create a `main.tf` file in your Terraform working directory:

   ```hcl
   module "gateway_api" {
     source  = "tf-kubernetes-iaac/api/gateway"
     version = "1.0.0"
     
     helm_release_name = "gateway-api"
     chart_version     = "0.2.0"
     gateway_version   = "1.5.0"
   }
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the Plan**:
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**:
   ```bash
   terraform apply
   ```

5. **Verify Installation**:
   ```bash
   kubectl get pods -n gateway-api-system
   kubectl get crds | grep gateway
   ```

## Troubleshooting

### Issue: Chart Pull Fails

**Solution**: Ensure you have access to the OCI registry:
```bash
helm repo update
```

### Issue: CRD Installation Fails

**Solution**: Check that your service account has sufficient RBAC permissions:
```bash
kubectl auth can-i create customresourcedefinitions --as=system:serviceaccount:default:default
```

### Issue: Gateway API Version Mismatch

**Solution**: Ensure the `gateway_version` is compatible with the `chart_version`. Check the [Gateway API documentation](https://gateway-api.sigs.k8s.io/) for compatibility information.

## Gateway API Resources

After installation, you can use the following Gateway API resources:

- **GatewayClass**: Cluster-scoped resource that defines types of Gateways available
- **Gateway**: Namespace-scoped resource that represents a request to expose services
- **HTTPRoute**: HTTP routing resource for directing traffic
- **TCPRoute**: TCP routing resource for transport layer routing
- **TLSRoute**: TLS routing with SNI matching

Example HTTPRoute:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-route
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - "example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /api
    backendRefs:
    - name: api-service
      port: 8080
```

## Upgrading the Module

To upgrade the Gateway API version:

```hcl
module "gateway_api" {
  source = "./terraform-gateway-api"
  
  gateway_version = "1.6.0"  # Update to newer version
  chart_version   = "0.3.0"  # Update chart if needed
}
```

Run `terraform plan` to review changes and then `terraform apply` to update.

## Variables

### helm_release_name

- **Description**: The name of the Helm release. If not specified, defaults to `helm-gateway-api-release`
- **Type**: `string`
- **Default**: `""` (empty, triggers auto-generation)
- **Example**: `"my-gateway"`

### chart_version

- **Description**: The version of the Helm chart to use
- **Type**: `string`
- **Default**: `"0.2.0"`
- **Example**: `"0.3.0"`

### gateway_version

- **Description**: The version of the Kubernetes Gateway API to install
- **Type**: `string`
- **Default**: `"1.5.0"`
- **Example**: `"1.6.0"`

### channel

- **Description**: The installation channel (affects which features are available)
- **Type**: `string`
- **Default**: `"standard"`
- **Options**: `"standard"`, `"experimental"`

## Known Limitations

- This module uses the Helm provider, so all Helm provider limitations apply
- The module does not manage the underlying Kubernetes cluster
- RBAC permissions must be manually configured before using this module
- Requires an existing Kubernetes provider configuration

## Related Modules

This module is part of a collection of Kubernetes-focused Terraform modules:

- `terraform-kubernetes-namespace`: Manage Kubernetes namespaces
- `terraform-kubernetes-service`: Manage Kubernetes services
- `terraform-kubernetes-service-account`: Manage Kubernetes service accounts
- `terraform-kubernetes-limit-range`: Manage resource limits

## Resources

- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [nicklasfrahm/charts Repository](https://github.com/nicklasfrahm/charts)
- [Kubernetes Helm Documentation](https://helm.sh/docs/)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)

## License

This module is provided as-is for learning and development purposes.

## Support

For issues, questions, or improvements, please refer to the documentation and examples provided in this module.
