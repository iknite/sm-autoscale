export TF_VAR_org_id=

export TF_VAR_project_id=sm-autoscale

export GCP_IAM_ACCOUNT=${TF_VAR_project_id}@${TF_VAR_project_id}.iam.gserviceaccount.com

export GOGLE_CREDENTIALS=${PWD}/gcp.json

export TF_VAR_gcp_region=europe-west6  # http://www.gcping.com/

export TF_VAR_master_username="admin"

export TF_VAR_master_password="admin"


# Blue cluster
export TF_VAR_blue_cluster_name="blue-cluster"

export TF_VAR_blue_cluster_region=${TF_VAR_gcp_region}

export TF_VAR_blue_enabled=1


# Green cluster
export TF_VAR_green_cluster_name="green-cluster"

export TF_VAR_green_cluster_region=${TF_VAR_gcp_region}

export TF_VAR_green_enabled=0
