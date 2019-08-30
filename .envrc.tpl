export TF_VAR_org_id=

export TF_VAR_project_id=sm-autoscale

export GCP_IAM_ACCOUNT=${TF_VAR_project_id}@${TF_VAR_project_id}.iam.gserviceaccount.com

export GOGLE_CREDENTIALS=${PWD}/gcp.json

export TF_VAR_gcp_location=europe-west6  # http://www.gcping.com/

export TF_VAR_gke_version=1.12.9-gke.15

export TF_VAR_istio_version=1.1.13

export TF_VAR_master_username="admin"

export TF_VAR_master_password="adminadminadmin1"


# Blue cluster
export TF_VAR_blue_cluster_name="blue-cluster"

export TF_VAR_blue_cluster_location=${TF_VAR_gcp_location}

export TF_VAR_blue_enabled=1


# Green cluster
export TF_VAR_green_cluster_name="green-cluster"

export TF_VAR_green_cluster_location=${TF_VAR_gcp_location}

export TF_VAR_green_enabled=0


# Application autocale boundaries
export APP_CPU=50 #percentaje

export APP_MIN=1

export APP_MAX=10
