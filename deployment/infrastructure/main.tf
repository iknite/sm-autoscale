variable "project_id" {}
variable "gcp_location" {}
variable "gke_version" {}
variable "istio_version" {}
variable "master_username" {}
variable "master_password" {}
variable "blue_cluster_name" {}
variable "blue_cluster_location" {}
variable "blue_enabled" {}
variable "green_cluster_name" {}
variable "green_cluster_location" {}
variable "green_enabled" {}

locals {
  colors = [
    {
      enabled  = var.blue_enabled
      name     = var.blue_cluster_name
      location = var.blue_cluster_location
    },
    {
      enabled  = var.green_enabled
      name     = var.green_cluster_name
      location = var.green_cluster_location
    }
  ]
}

module "istio_cluster" {
  source = "./modules/istio_cluster"

  gcp_project      = var.project_id
  gke_version      = var.gke_version
  istio_version    = var.istio_version
  gcp_location     = var.gcp_location
  master_username  = var.master_username
  master_password  = var.master_password
  cluster_name     = var.blue_cluster_name
  cluster_location = var.blue_cluster_location

}
