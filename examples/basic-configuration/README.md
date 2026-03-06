# Basic Configuration Example

This example demonstrates the simplest way to deploy the Kubernetes Gateway API module using Terraform with default configuration values.

## Overview

This example uses all default values provided by the module, making it the quickest way to get started with Gateway API in your Kubernetes cluster.

## Configuration

The basic configuration uses the following defaults:

- **Module Source**: `tf-kubernetes-iaac/api/gateway`
- **Module Version**: `1.0.0`
- **Helm Release Name**: `helm-gateway-api-release` (auto-generated)
- **Chart Version**: `0.2.0`
- **Gateway API Version**: `1.5.0`
- **Channel**: `standard`

## Prerequisites

Before running this example, ensure you have:

- Terraform 1.3 or later installed
- A running Kubernetes cluster
- `kubectl` configured to access your cluster
- Helm provider properly configured

## Usage

### Step 1: Navigate to the Example Directory

```bash
cd examples/basic-configuration
```

### Step 2: Initialize Terraform

This initializes the Terraform working directory and downloads required providers and modules.

```bash
terraform init
```

### Step 3: Review the Plan

Before applying changes, review what Terraform will create:

```bash
terraform plan
```

This will show you that the Gateway API module will be deployed with default settings.

### Step 4: Apply the Configuration

Deploy the Gateway API:

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### Step 5: Verify the Deployment

After Terraform completes, verify that the Gateway API has been installed:

```bash
# Check the Helm release
helm list

# Check if Gateway API CRDs are installed
kubectl get crds | grep gateway

# Check pods in the gateway-api-system namespace (if applicable)
kubectl get pods -n gateway-api-system
```

## What Gets Deployed

This configuration deploys:

1. **Gateway API CRDs**: Custom Resource Definitions including:
   - GatewayClass
   - Gateway
   - HTTPRoute
   - TCPRoute
   - TLSRoute
   - And other related resources

2. **Helm Release**: Manages the lifecycle of the deployed resources

## Cleanup

To remove the Gateway API deployment:

```bash
terraform destroy
```

When prompted, type `yes` to confirm deletion.

## Troubleshooting

### Issue: Terraform Cannot Find the Module

**Error**: `Error: module not found`

**Solution**: Ensure you're running terraform from the example directory and the module path is correct:

```bash
# Verify the correct directory structure
ls -la ../..  # Should show terraform-gateway-api files
```

### Issue: Helm Provider Authentication Fails

**Error**: `Error authenticating: invalid credentials`

**Solution**: Ensure your kubeconfig is properly configured:

```bash
# Check your kubeconfig
cat ~/.kube/config

# Or switch to the correct context
kubectl config use-context <your-cluster>
```

### Issue: CRD Already Exists

**Error**: `Error from server (AlreadyExists)`

**Solution**: The Gateway API CRDs might already be installed from a previous installation. Run:

```bash
terraform import helm_release.gateway_api gateway-api-release
```

## Next Steps

After deploying with this basic configuration, you can:

1. **Create Gateway Resources**: Define GatewayClass and Gateway resources
2. **Set Up Routes**: Create HTTPRoute resources to route traffic
3. **Configure TLS**: Use TLSRoute for encrypted communication
4. **Explore Complete Example**: See [complete-configuration](../complete-configuration/) for more advanced options

## Example: Using Gateway API After Deployment

Once deployed, you can create Gateway API resources:

```yaml
## Create a GatewayClass
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: my-gateway-class
spec:
  controllerName: example.com/gateway-controller

---
## Create a Gateway
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: my-gateway-class
  listeners:
  - name: http
    protocol: HTTP
    port: 80

---
## Create an HTTPRoute
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-route
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - example.com
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /api
    backendRefs:
    - name: api-service
      port: 8080
```

## Key Files

- **main.tf**: Terraform configuration that deploys the Gateway API module
- **../../terraform-gateway-api/**: The source module with all the deployment logic

## Additional Resources

- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Kubernetes Helm Documentation](https://helm.sh/docs/)
- [Terraform Helm Provider Docs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
