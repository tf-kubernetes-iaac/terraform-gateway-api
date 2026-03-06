output "release_id" {
  description = "The unique identifier of the Helm release"
  value       = helm_release.gateway_api.id
}

output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.gateway_api.name
}

output "release_namespace" {
  description = "The namespace where the Helm release is deployed"
  value       = helm_release.gateway_api.namespace
}

output "release_status" {
  description = "The status of the Helm release"
  value       = helm_release.gateway_api.status
}

output "chart_version" {
  description = "The version of the Helm chart deployed"
  value       = helm_release.gateway_api.version
}

output "gateway_api_version" {
  description = "The version of the Gateway API CRDs that were installed"
  value       = var.gateway_version
}

output "installation_channel" {
  description = "The installation channel used for Gateway API"
  value       = var.channel
}

output "chart_repository" {
  description = "The OCI repository URL of the Gateway API Helm chart"
  value       = "oci://ghcr.io/nicklasfrahm/charts/gateway-api"
}

output "helm_release_attributes" {
  description = "Complete Helm release attributes"
  value = {
    id              = helm_release.gateway_api.id
    name            = helm_release.gateway_api.name
    namespace       = helm_release.gateway_api.namespace
    chart           = helm_release.gateway_api.chart
    version         = helm_release.gateway_api.version
    status          = helm_release.gateway_api.status
    values          = helm_release.gateway_api.values
  }
  sensitive = false
}

output "verification_commands" {
  description = "Commands to verify the Gateway API deployment"
  value = {
    check_helm_release = "helm list | grep ${helm_release.gateway_api.name}"
    check_crds         = "kubectl get crds | grep gateway"
    check_pods         = "kubectl get pods --all-namespaces | grep gateway"
    get_release_info   = "helm get all ${helm_release.gateway_api.name}"
    get_gateways       = "kubectl get gateways --all-namespaces"
  }
}
