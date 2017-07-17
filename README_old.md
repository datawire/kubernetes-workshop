# Introduction to Kubernetes and Microservices Workshop

Hi Folks! This is going to be a workshop where I teach the basics of Kubernetes from both the Ops and Developers perspective. Ultimately by the end you should know enough Kubernetes to be dangerous! What that means is you will know the core concepts in Kubernetes, which commands are really powerful and important and how to use them and have some experience building and deploying an app on Kubernetes. We'll also cover Kubernetes and CI/CD as well as developer experience using Kubernetes.

## Workshop Prerequisite Software and Configuration

Workshop attendees need to configure there system properly and install a few tools to interact with Kubernetes. Some of you may already be ready to go while others will need to install a handful of tools.

## Before You Do Anything!

Ensure CPU virtualization is enabled in your computer's BIOS. CPU virtualization is **required** in order to run a virtual machine instance of Kubernetes called [Minikube](https://github.com/kubernetes/minikube). You can follow the questions below to determine if you need to configure your BIOS:

1. Are you using a Mac?
    - **Yes** - Continue to [Install Minikube](#install-minikube)

2. Are you using a PC (Windows or Linux)?
    1. Have you ever run virtualization software before on *this* computer (e.g. VirtualBox, VMWare Fusion, or KVM)?
        - **Yes** - Continue to [Install Minikube](#install-minikube)
        - **No or Unsure** - Reboot and enter your computers BIOS. You have to find a setting named `Intel Virtualization Technology (Intel-VT)`, `AMD-V` or `VT-x` and enable it. Once that's done you can continue to [Install Minikube](#install-minikube)

## Install Minikube

Minikube is a standalone distribution of Kubernetes designed for experimentation, development and testing. Minikube installs and runs as virtual machine on your local computer rather than requiring a remote cluster in your DC or cloud provider. Please follow the [official installation instructions for Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube).

Once installed run the following command to ensure it's on your path:

```console
$ minikube version
```

The console should display something similar to `minikube version: v0.19.0`. Please ensure you're using a version of `minikube` greater than or equal to `v0.19.0` for this workshop.

The `kubectl` (pronounced "cube-cuttle") command should also be installed if you followed the instructions correctly:

```console
$ kubectl version --client --short
```

The console should display something similar to `Client Version: v1.6.4`. Please ensure you're using a version of `kubectl` greater than or equal to `v1.6.4` for this workshop.

Finally test that `minikube` and `kubectl` really actually work:

```console
$ minikube start

Starting local Kubernetes v1.6.0 cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.

$ kubectl cluster-info

Kubernetes master is running at https://192.168.99.100:8443
```

If you see something similar to `Kubernetes master is running at https://192.168.99.100:8443` you're good to go!

## Install Kubectl

If you followed the [Install Minikube](#install-minikube) section correctly then `kubectl` is installed and configured already. If you did not follow those instructions then you should follow the [official installation instructions for Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

Once you have `kubectl` then run the command `kubectl version --client --short`. Please ensure you're using a version of `kubectl` greater than or equal to `v1.6.4` for this workshop.

## Install Docker

Docker is required to build and push container images on your local computer. Please follow the [official installation instructions for Docker](https://docs.docker.com/engine/installation/).

Verify that the `docker` command works by running `docker version`. The displayed output should be similar to below (please verify version is greater than or equal to `1.13`:

```console
Client:
 Version:      1.13.1
 API version:  1.26

Server:
 Version:      1.13.1
 API version:  1.26 (minimum version 1.12)
```

If you're using `docker-ce` then version scheme is a bit different. It should be similar to this:

```console
Client:
 Version:      17.03.1-ce
 API version:  1.27

Server:
 Version:      17.03.1-ce
 API version:  1.27 (minimum version 1.12)
```

## Install Git

You will need access to Git for this workshop.

* Red Hat / Fedora : `dnf install git`
* Ubuntu : `apt-get install git`
* OS X: Use [Homebrew](https://brew.sh/) or follow the instructions on the main Git website.

## Install Telepresence

If we have time I'll show you a cool mechanism to bridge a Kubernetes cluster to your local laptop so that you can do stuff like view volumes on Kubernetes and run a local debugger against a Kubernetesified service.

[Please read and follow the installation instructions for Telepresence](http://www.telepresence.io/tutorials/kubernetes.html).
