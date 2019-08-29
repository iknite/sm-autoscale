variable "gcp_project" {
  description = "The name of the GCP Project where all resources will be launched."
}

variable "gcp_location" {
  description = "The location in which all GCP resources will be launched."
  default     = "europe-west6"
}

variable "cluster_name" {
  description = "GKE cluster name"
}

variable "gke_version" {
  description = "Kubernetes cluster master version"
  default     = "1.13.7-gke.24"
}

variable "master_username" {
  description = "GKE cluster master username"
}

variable "master_password" {
  description = "GKE cluster master password"
}

variable "cluster_location" {
  description = "GKE cluster location"
}

variable "helm_repository" {
  description = "Helm repository where the istio chart release is published"
  default     = "https://kubernetes-charts.storage.googleapis.com/"
}

variable "istio_version" {
  description = "Istio chart version"
  default     = "1.1.13"
}

variable "min_node_count" {
  description = "GKE cluster initial node count and min node count value"
  default     = 1
}

variable "max_node_count" {
  description = "GKE cluster maximun node autoscaling count"
  default     = 5
}

