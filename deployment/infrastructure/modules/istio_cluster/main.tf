resource "google_container_cluster" "gke_cluster" {
  provider = "google-beta"

  name               = var.cluster_name
  location           = var.gcp_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 2

  min_master_version = var.gke_version

  master_auth {
    username = var.master_username
    password = var.master_password
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    istio_config {
      disabled = false
    }

  }

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      maximum       = 10
      minimum       = 4
    }

    resource_limits {
      resource_type = "memory"
      maximum       = 58
    }

  }

}

resource "google_container_node_pool" "gke_node_pool" {
  provider = "google-beta"

  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.gcp_location

  initial_node_count = var.min_node_count

  management {
    auto_repair = true
    auto_upgrade = false
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }
}

# resource "null_resource" "install_istio" {
#   triggers = {
#     cluster_ep = google_container_cluster.gke_cluster.endpoint
#   }
#
#   provisioner "local-exec" {
#     command = <<EOF
#       set -xeu
#
#       gcloud container clusters get-credentials ${var.cluster_name} \
#         --region ${var.gcp_location} \
#         --project ${var.gcp_project}
#
#       helm repo add istio.io \
#         https://storage.googleapis.com/istio-release/releases/${var.istio_version}/charts/
#       helm repo update
#
#       istio_path=".download/istio-${var.istio_version}"
#
#       if [ ! -d $istio_path ]; then
#         mkdir -p .download && cd .download
#         curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${var.istio_version} sh -
#         sleep 1
#       fi
#
#       (
#         cd $istio_path
#
#         kubectl apply -f install/kubernetes/helm/helm-service-account.yaml
#
#         helm init --service-account tiller --wait
#
#         # BUG: helm doesn't handle extra whitespaces
#         # https://github.com/helm/helm/issues/5863
#
#         helm upgrade istio-init install/kubernetes/helm/istio-init --install --wait --namespace istio-system --version ${var.istio_version}
#
#         helm upgrade istio install/kubernetes/helm/istio --install --wait --namespace istio-system --version ${var.istio_version}
#
#       )
#
#     EOF
#
#   }
#
#   depends_on = [google_container_node_pool.gke_node_pool]
# }
