
# Design

In the pursue of an autoscalable, (fully) automated and resilient infrastucture 
for microservices, using the correct set of tools to allow fast deliveries and 
resilient deployment is a matter of utmost importance. 


In order to maximize resilience and automation Istio is selected due to his
capabilities<sup>1</sup> of **Continous Delivery** with weighted loads (canary 
releases) user routing (A/B testing), version multiplexion. **Resilience** is
other of the strengs of Istio due to the circuit-breaker pattern, throttling,
timed out and retriable queries, and pool ejection.

Design Goals:
- (Micro)Service Oriented Architecture
- Autoscalable
- Resilient
- Automatable

### Autoscaling

Autoscaling is archieved with the HPA<sup>1</sup> module of Kubernetes alongside
the GKE Cluster autoscaler<sup>2</sup>. Since this design is single cluster, 
once reached natural limits of single clustering<sup>3</sup>, shifting to a 
Multicluster configuration can be easily<sup>4</sup> done.

### Resiliency

Alonside Autoscaling, resiliency is a must in any bizantine system. Creating a 
multi-master node configuration, called regional clusters<sup>5</sup> disables
single point of failure in kubernetes orchestration and scheduling. 

Similarly Istio's control plane has the same contraints as the master nodes.
Running and configured pods can still be used, but new pods can't be configured,
so in a network outage event it's a SPOF (single point of failure). Istio's 
control plane can be configured in HA<sup>6</sup> with replicaSets and 
AntiAffinity rules.

### Automation

Terraform is used as Infrastructe as code, because it's declarative, creates
a optimized resource graph. gcloud and kubectl, are responsible to prove and 
setup the cluster. And as a wrapper around all the tools, Makefiles orchestrate
the lifecycle.

This repository is meant as Bastion for deployment. If can be externally
configurable with environment variables and use envconsul<sup>7</sup> and
vault as configuration management for release-cycle secrets and configuration.

# Design analysis.

Design Analysis:
- Orchestration
- Configuration Management
- Single Point of Failures
- Telemetry
- Tests

### Orchestration

Infrastructure lifecycle orchestration can be archieved with **Spinakker** over 
the terraform scripts as the platform<sup>8</sup> suggest. It enables blue/green
canary and rolling relase strategies.

While application lifecyle management will be performed with Istio's Proxy and 
Mixer capabilites. traffic-shifting, user-routing, and RBAC policies among others
orchestrated with flagger<sup>9</sup>.


### Configuration Management

Application Management can be performed with the **etcd** provided in 
kubernetes. Operational secrets will be in Istio's **Citadel** for credential
management, and **Pilot** for traffic routing, throttling and circut-braking
policies, and **Mixer** for ABAC/RBAC control policies. Using kiali<sup>10</sup>
will be easier for observability.

### Single Point of failures

Detect SPOFs are without doubt one of the main aspects in service design 
architectures. DNS providers, Third-party downloads, ceritificate providers, 
everything if fallible and can create outages.

In this design there is some known SPOFs. 
- The bastion: Terraform uses a single point of truth that if stored
incorrectly (like the defaults in this repo) could end up in misconfigurations.
- Istio's Control Plane: it's configured without HA so, newtork problems between 
cluste nodes, can end up impedding the lifecycle of the applications.
- Kubernetes Master Node: If configured to have only one it will suffer as Istio
from the same network outages.
- Single Ingress Endpoint: Having only one endpoint can brake the system if it 
becomes unreachable. 
- Third party downloads: all external downloads are subject to create problems
if, for example github is unreachable. 

### Telemetry
- Monitoring: Kubernetes and Istio comes with Prometheus out of the box and easily configurable.
- Tracing: Jaeger can be easily installed with helm to aggregate traffic around queries.
- Logging:  Envoy will collect the logging and using Fluentd it can be properly.
- Observability: Kiali can show 

### Tests
- App stress test: using fortio (like this example)
- Chaos engineering: using the chaos toolkit to design network outages,
application failures among others<sup>11</sup>


# Alternatives

While Kubernetes and Istio seems to track all the attention these days,
we must be diligent in testing or at least acknowledge the goodness them.
Notably, Linkerd and Consul Connect as Service Meshes and Nomad as Orchestrators.

As expected Istio’s Envoy proxy uses more than 50% more CPU than Linkerd’s, in
some test scenarios. Linkerd’s control plane uses a tiny fraction of Istio’s,
especially when considering the “core” components. So unless the planned
workload requires that kind of specialization, or you can’t afford the extra
cost of resources, you should test Linkerd2 or Consul.

Nomad only aims to provide cluster management and scheduling and is designed
with the Unix philosophy of having a small scope while composing with tools
like Consul for service discovery and Vault for secret management. While
Kubernetes is specifically focused on Docker, Nomad is more general purpose.
Nomad supports virtualized, containerized and standalone applications,
including Docker.


# References.
- [1] https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
- [2] https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler
- [3] https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/proposals/scalability_tests.md
- [4] https://github.com/GoogleCloudPlatform/terraform-google-examples/blob/master/example-gke-k8s-multi-region/main.tf
- [5] https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters
- [6] https://docs.vmware.com/en/VMware-Cloud-PKS/services/com.vmware.cloudpks.using.doc/GUID-227047F4-5CA8-4111-807C-B1BAB6CCCAA4.html
- [7] https://github.com/hashicorp/envconsul
- [8] https://cloud.google.com/solutions/continuous-delivery-spinnaker-kubernetes-engine
- [9] https://github.com/weaveworks/flagger
- [10] https://www.kiali.io/documentation/features/
- [11] https://en.wikipedia.org/wiki/Chaos_engineering
