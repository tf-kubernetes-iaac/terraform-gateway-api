variable "helm_release_name" {
  description = "Enter the name of the release"
  type = string
  default = ""
  
}

variable "chart_version" {
  description = "Enter the version of chart for Gateway API."
  type = string
  default = "0.2.0"
}

variable "gateway_version" {
  description = "Enter the version of gateway API that you want to install."
  type = string
  default = "1.5.0"
}

variable "channel" {
  description = "Enter the channel from where you want to install Gateway API. (Default: standard)"
  type = string
  default = "standard"
  
}