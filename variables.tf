variable "version" {
  type = string
  description = "Enter the version of gateway api resource that you want to install."

}

variable "channel" {
  type = string
  description = "Enter the channel of Gateway API Resource that you want to install."
  default = "stable"

  validation {
    condition = contains(["stable","experimental"], var.channel)
    error_message = "channels must be either stable or experimental."
  }
}