variable "org_id" {}

variable "project_id" {}

resource "google_project" "sm-autoscale" {
  name       = var.project_id
  project_id = var.project_id
  org_id     = var.org_id
}

