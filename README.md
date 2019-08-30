# Service Mesh Autoscale Test

A autoscale, (fully) automated, Infrastructure as code aproach to Istio.

## Design Overview

In a world of containers and microservices, the management complexity scalates,
understanding complex behaviours under heavy distributed workloads is
challenging to say the least, while scaling but don’t overprovision is a must.

Full architectural design can be found in [ARCHITECTURE.md](./ARCHITECTURE.md)

## Installation

In order to run the following we need a GCP account. And highly recomend the
FREE TIER activation
https://cloud.google.com/free/docs/gcp-free-tier

> IMPORTANT. You must visit the `Kubernetes engine` page in order to enable the
> API. :face-palm:

Once you get that manual step ready, please fetch the ORG_ID and store it
in the .envrc file in `TF_VAR_org_id`.

##### Required packages
- make 4.1
- terraform 0.12.7
- gcloud 259.0.0
- kubectl 1.15.3
- curl 7.58.0
- golang 1.12.8

##### Optional packages
- direnv (you must load manually perform `make .envrc` steps)
- helm 2.14.3

## Usage

```sh
# TL; DR
make infra
make topology
make deploy
make stress
```

### Infrastructure

First time lanching `make infra` it will create 2 files, `.envrc` for direnv
and `gcp.json` for gcloud credentials. It requires a `TF_VAR_org_id` filled
with the correct **org_id**.

- `.envrc` is created by coping `.envrc.tpl` and letting you edit the file to
populate the *project_id* value. 
- `gcp.json` is created by first, create a project with **terraform** in the 
google acount with the name of `TF_VAR_project_id` (default: **sm-autoscale**)
and use the newly created project to generate the gcp.json file and store it 
`GOOGLE_CREDENTIALS` for later scripts.
- `make infra` will launch the terraform for create a gke stack with istio. 

### Application

Once the environment is completed is time to tweack the application to launch. 
inside the `src` folder there is a `service-graph.yaml` file that describes a
graph to test istio capabilities. it uses [istio-tools/isotope](https://github.com/istio/tools/tree/master/isotope)
to quicly draft connectivity graphs. you can uses the examples in the
`example-topologies` folder of that repo.

As public entrypoint it exposes a [fortio](https://github.com/fortio/fortio) app
to stress the previosly created graph.

- `make topology` translates the `service-graph.yaml` to a `topology-path.yaml`
automatically to kubernetes, but it can be translate to graphviz also to see it.

### Deployment

Once you have a target infrastructe and a `topology-path.yaml` is time to
upload the application.

- `make deploy` will create the deployment with kubectl, create a autoscale rule
and expose the fortio client to in ingress endpoint `<ingress_endpoint>:8080/fortio`






