.DEFAULT_GOAL := help
SHELL ?= /bin/bash

.PHONY: help
help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.envrc:
	@cp envrc.tpl .envrc
	########## Fill TF_VAR_project_id value ##########

gcp.json:  .envrc ## Generate gcp credentials
	@gcloud auth application-default login
	@cd deployment/gcp_project && terraform apply
	@gcloud config set project ${TF_VAR_project_id}
	@gcloud iam service-accounts create ${TF_VAR_project_id}
	@gcloud iam service-accounts keys create gcp.json --iam-account=${GCP_IAM_ACCOUNT}

