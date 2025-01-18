# Arquivo principal do Terraform onde você define recursos, providers, etc.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google-beta" {
  project = var.PROJECT
  region  = var.REGION
}
