# Basic Configuration Example
# This example demonstrates the simplest way to deploy the Gateway API module
# using default values for all configuration options.

terraform {
  required_version = "~> 1.3"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.0"
    }
  }
}

# Configure the Helm provider to use your Kubernetes cluster
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Deploy Gateway API with default configuration
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  # All variables use their default values:
  # - helm_release_name: "helm-gateway-api-release"
  # - chart_version: "0.2.0"
  # - gateway_version: "1.5.0"
  # - channel: "standard"
}

# Outputs can be displayed to verify the deployment
output "message" {
  value = "Gateway API has been deployed with default settings"
}
