# Custom Versions Example
# This example demonstrates how to deploy specific versions of Gateway API
# and shows how to update versions over time.

terraform {
  required_version = "~> 1.3"

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
  }
}

# Example 1: Latest Stable Versions
# Uncomment this block to deploy the latest stable versions
/*
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-latest"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}
*/

# Example 2: Specific LTS-like Version
# Deploy a specific older but stable version
module "gateway_api_stable" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-stable"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}

# Example 3: Experimental/Beta Version
# Uncomment to test experimental features
/*
module "gateway_api_experimental" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-experimental"
  chart_version     = "0.2.0"
  gateway_version   = "1.6.0"
  channel           = "experimental"
}
*/

# Example 4: Side-by-side Deployments
# Deploy multiple versions for testing or gradual migration
/*
module "gateway_api_v1_5" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-v1-5"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}

module "gateway_api_v1_6" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-v1-6"
  chart_version     = "0.3.0"
  gateway_version   = "1.6.0"
  channel           = "standard"
}
*/

# Outputs
output "deployed_version" {
  description = "The Gateway API version deployed"
  value       = "1.5.0"
}

output "chart_version" {
  description = "The Helm chart version used"
  value       = "0.2.0"
}

output "deployment_notes" {
  description = "Important notes about this deployment"
  value       = <<-EOT
    Version Management Best Practices:
    
    1. Test new versions in development first
    2. Use terraform plan to review version changes
    3. Keep detailed notes of version decisions
    4. Test application compatibility with new versions
    5. Have a rollback plan ready
    
    To update versions:
    1. Modify the chart_version and/or gateway_version values
    2. Run: terraform plan
    3. Review the changes carefully
    4. Run: terraform apply
    
    To test multiple versions:
    - Uncomment Example 4 in this file
    - Deploy multiple instances with different versions
    - Test your applications with each version
  EOT
}
