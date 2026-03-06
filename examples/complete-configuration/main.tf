# Complete Configuration Example
# This example demonstrates full customization of the Gateway API module
# with explicit values for all available configuration options.

terraform {
  required_version = "~> 1.3"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.0"
    }
  }
}

# Configure the Helm provider with explicit Kubernetes connection details
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    # You can also specify the context if you have multiple
    # config_context = "my-kubernetes-context"
  }
}

# Deploy Gateway API with complete customization
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  # Explicitly specify the Helm release name
  helm_release_name = "custom-gateway-api"
  
  # Specify the Helm chart version
  chart_version = "0.2.0"
  
  # Specify the Gateway API version to install
  gateway_version = "1.5.0"
  
  # Specify the installation channel
  # Options: "standard" (default), "experimental"
  channel = "standard"
}

# Output useful information about the deployment
output "release_name" {
  description = "The name of the Helm release"
  value       = module.gateway_api.gateway_api.id
}

output "chart_version" {
  description = "The version of the Gateway API Helm chart deployed"
  value       = "0.2.0"
}

output "gateway_api_version" {
  description = "The version of the Gateway API that was installed"
  value       = "1.5.0"
}

output "installation_channel" {
  description = "The installation channel used"
  value       = "standard"
}

output "deployment_instructions" {
  description = "Instructions for verifying the deployment"
  value       = <<-EOT
    Verification steps:
    
    1. Check Helm release:
       helm list
    
    2. Check Gateway API CRDs:
       kubectl get crds | grep gateway
    
    3. Check Gateway API pods:
       kubectl get pods --all-namespaces | grep gateway
    
    4. Verify GatewayClass:
       kubectl get gatewayclass
    
    For more information, visit: https://gateway-api.sigs.k8s.io/
  EOT
}
