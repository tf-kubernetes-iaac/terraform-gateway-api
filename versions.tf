terraform {
  required_version = ">= 1.0"

    required_providers {
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.30.0"
        }
        http = {
            source = "hashicorp/http"
            version = "3.4.0"
        }
    }
}