
# Design

In the pursue of an autoscalable, (fully) automated and resilient infrastucture 
for microservices, using the correct set of tools to allow fast deliveries and 
resilient insta

Design Goals:
- microservice oriented architecture
- autoscalable
- resilient
- automatable

In order to maximize resilience and automation Istio is selected due to his
capabilities<sup>1</sup> of **Continous Delivery** with weighted loads (canary gradual releases)
user routing (A/B testing), version multiplexion. **Resilience** is other of
the strengs of Istio due to the circuit-breaker pattern, throttling, timed out
and retriable queries, and pool ejection.

Autoscaling is archieved with the HPA<sup>2</sup> 

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


# External References.
[1] https://www.oreilly.com/library/view/introducing-istio-service/9781491988770/ch04.html
[2] https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
[3] https://github.com/ContainerSolutions/k8s-deployment-strategies
[4] https://cloud.google.com/solutions/continuous-delivery/
[5] https://cloud.google.com/solutions/continuous-delivery-spinnaker-kubernetes-engine


