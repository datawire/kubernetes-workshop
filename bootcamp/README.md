# Kubernetes Bootcamp Exercises

Exercises to get you started and comfortable with Kubernetes. The exercises are written to teach from the basic foundations of Kubernetes all the way to building and deploying applications on Kubernetes.

## Prerequisites

You need to have the below tools installed:

* Docker
* Kubectl
* Git

For the workshop you need a Docker Registry that can be accessed by the Kubernetes cluster. Run the below command to login to a public shared registry just for the workshop. If you want to use your own Docker Registry then you may skip this step, however, please note that the shared training cluster is only configured to use a Docker Hub Registry.

```console
$> docker login -u datawiretraining -p training2017_

Login Succeeded
```

Please note that the registry will be purged after the workshop concludes along with the shared Kubernetes cluster.

### Docker Exercises

1. [Running Containers](bootcamp/containers.md)
2. [Building Docker Images](bootcamp/images.md)
3. [Sharing Docker Images](bootcamp/sharing-images.md)

### Kubernetes Exercises