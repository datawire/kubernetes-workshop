# Docker 101 Exercises

Exercises to get you started and comfortable with Docker. The exercises are written to help you learn what Docker does and how it is used to create, share and ship software.

## Prerequisites

You need to have the below tools installed:

* Docker

Also you need a Docker Registry that can be accessed by the training Kubernetes cluster. For convenience we have a shared Docker Registry that you can use. Login to the registry with the below command. Please remember that the registry is purged after the workshop concludes along with the training Kubernetes cluster.

```console
$> docker login -u datawiretraining -p training2017_

Login Succeeded
```

### Exercises

1. [Running Containers](docker_101/containers.md)
2. [Building Docker Images](docker_101/images.md)
3. [Sharing Docker Images](docker_101/shipping.md)
