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
	@sleep 5
	@${EDITOR} .envrc
	@direnv allow

.PHONY: gcp_project
gcp_project: .envrc  ## create gcp_project
	@gcloud auth application-default login
	@cd deployment/gcp_project && terraform init && terraform apply --auto-approve

gcp.json: .envrc  ## Generate gcp credentials
	@gcloud auth application-default login
	@gcloud config set project ${TF_VAR_project_id}
	@gcloud iam service-accounts create ${TF_VAR_project_id}
	@gcloud iam service-accounts keys create gcp.json --iam-account=${GCP_IAM_ACCOUNT}

.PHONY: cred
cred:  ## get credentials for kubectl
	@gcloud container clusters get-credentials ${TF_VAR_blue_cluster_name} \
		--zone ${TF_VAR_gcp_location} \
		--project ${TF_VAR_project_id}

.PHONY: infra
infra: gcp.json  ## creates the isito cluster
	@cd deployment/infrastructure && terraform init && terraform apply --auto-approve

.PHONY: topology
topology: ## creates the topology path to deploy
	@go mod download
	@go run istio.io/tools/isotope/convert kubernetes \
		--service-image tahler/isotope-service:1  \
		--client-image tahler/fortio:prometheus   \
		src/service-graph.yaml > src/topology-path.yaml

.PHONY: deploy
deploy: ## deploy application in enviroment
	@kubectl create -f src/topology-path.yaml
	@kubectl -n service-graph autoscale deployment app --cpu-percent=${APP_CPU} --min=${APP_MIN} --max=${APP_MAX}
	@kubectl patch svc client -p '{"spec": {"type": "LoadBalancer"}}'

.PHONY: stress
stress:  ## stress the installation
	@./tests/stress/stress.sh

.PHONY: clean
clean: ## remove clutter
	@git clean -f

.PHONY: wipe
wipe: ## remove terraform state cache files, deployment and project in GCP. 
	@cd deployment/infrastructure && terraform init && terraform destroy --auto-approve
	@cd deployment/gcp_project && terraform init && terraform destroy --auto-approve
	@git clean -fX

