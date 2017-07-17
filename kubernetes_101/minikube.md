# Running a Kubernetes Cluster Locally

Minikube is a complete Kubernetes cluster in a box. The single-node cluster runs in a virtual machine right on your computer, running the same software as a normal Kubernetes cluster.

## Tutorial

### Starting Minikube 

On your computer run the following command to start the Minikube.

```console
$ minikube start
```

It takes about a minute for the VM to boot but once it is running Minikube should display some text on the console, the important bits are the last two lines `Setting up kubeconfig` and `Kubectl is now configured...` which really indicate Minikube is ready to use.

```console
Starting local Kubernetes v1.6.0 cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
```

Next, you're going to run a `kubectl` command that queries the cluster for information such as the URL of the Kubernetes master. Type `kubectl cluster-info` into the command line.

```console
$ kubectl cluster-info
Kubernetes master is running at https://192.168.99.100:8443

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

The `kubectl cluster-info` command is great for querying available endpoints of any Kubernetes cluster which on a more advanced cluster can be numerous.

### Stopping Minikube

To stop the Minikube run `minikube stop` and the VM hosting Minikube will shutdown. The great thing about `minikube stop` is you can resume whatever you were working on previously.

### Deleting Minikube

Sometimes you want a fresh slate to work on. You can do this with `minikube delete` which destroys the underlying VM.

### Accessing the Minikube Docker daemon

Under normal conditions you do not have access to Minikube's Docker daemon from your command line because Minikube is an isolated virtual machine.
However, it is useful to be able to use the Minikube Docker daemon directly (especially when building Docker images) because you can then run them right on the Kubernetes cluster without an intermediate step that pushes the Docker image to an external Docker Registry.

Try an experiment! Open two terminal windows and in the first window run the below command:

```console
$ docker ps
```

In the other terminal run:

```console
$ eval $(minikube docker-env)
$ docker ps
```

In the second terminal you have access to the Docker daemon within the VM.

### Accessing the VM

You can get a shell prompt inside the VM by running the following:

```console
$ minikube ssh
```

Try running `ps xa` to see what's running inside it.

### Takeaway

1. You can use Minikube to run a local Kubernetes cluster.
2. You can access Minikube's Docker server using `minikube docker-env`.
3. You can access the Minikube VM using `minikube ssh`.
