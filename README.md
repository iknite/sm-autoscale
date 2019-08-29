# Service Mesh Autoscale Test

A autoscale, (fully) automated, Infrastructure as code aproach to Istio. 

## Design Overview

In a world of containers and microservices, the management complexity scalates,
understanding complex behaviours under heavy distributed workloads is 
challenging to say the least, while scaling but don’t overprovision is a must.

Full architectural design can be found in [ARCHITECTURE.md](./ARCHITECTURE.md)

[Maglev](https://ai.google/research/pubs/pub44824)

## Installation

In order to run the following we need a GCP account. And highly recomend the
FREE TIER activation
https://cloud.google.com/free/docs/gcp-free-tier

> IMPORTANT. You must visit the `Kubernetes engine` page in order to enable the
> API. :face-palm:

Once you get that manual step ready, please fetch the PROJECT_ID and store it
in the .envrc file.


##### Required packages
- make 4.1
- terraform 0.12.7
- gcloud 259.0.0
- kubectl 1.15.3
- helm 2.14.3
- curl 7.58.0

##### Optional packages
- direnv (you must load manually perform `make .envrc` steps)

##### Installation guides:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
https://www.terraform.io/downloads.html
https://cloud.google.com/sdk/install
https://direnv.net/
