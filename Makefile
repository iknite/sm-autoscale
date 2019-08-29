.DEFAULT_GOAL := help
SHELL ?= /bin/bash

.PHONY: help
help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.envrc:
	@cp .envrc.tpl .envrc
	##################################
	# ! Fill TF_VAR_project_id value #
	##################################
	#
	# > launching editor in 5, 4, ...
	#
	@sleep 5
	@${EDITOR} .envrc
	@direnv allow

gcp.json:  .envrc ## Generate gcp credentials
	@gcloud auth application-default login
	@cd deployment/gcp_project && terraform apply
	@gcloud config set project ${TF_VAR_project_id}
	@gcloud iam service-accounts create ${TF_VAR_project_id}
	@gcloud iam service-accounts keys create gcp.json --iam-account=${GCP_IAM_ACCOUNT}

.PHONY: clean
clean: ## remove clutter
	@git clean -f

.PHONY: cred
cred:  ## get credentials for kubectl
	@gcloud container clusters get-credentials ${TF_VAR_blue_cluster_name} \
		--zone ${TF_VAR_gcp_location} \
		--project ${TF_VAR_project_id}

.PHONY: wipe
wipe: ## remove terraform state and cache files
	@git clean -fX
