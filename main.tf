resource "helm_release" "gateway_api" {
  chart = "oci://ghcr.io/nicklasfrahm/charts/gateway-api"
  name = var.helm_release_name != "" ? var.helm_release_name : "helm-gateway-api-release"
  version = var.chart_version

  set = [ 
    {
    name = "gatewayCRDInstaller.version"
    value = var.gateway_version
    },
    {
      name = "gatewayCRDInstaller.channel"
      value = var.channel
    } 
]
}