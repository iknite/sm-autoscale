variable "project_id" { type= number }

resource "google_project" "sm-autoscale" {
  name = "sm-autoscale"
  project_id = "sm-autoscale"
  org_id     = "${var.project_id}"
}

