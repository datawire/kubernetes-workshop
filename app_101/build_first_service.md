# Build a Microservices Application: The First Service

The interactive shell container is useful for quick debug and test situations but that is not what Kubernetes excels at. Kubernetes is great at running stateless web services and apps for long periods of time.

## Getting Started

On your computer clone the [`datawire/hello-kubernetes`](https://github.com/datawire/hello-kubernetes) Git repository:

```console
$ git clone https://github.com/datawire/hello-kubernetes.git
Cloning into 'hello-kubernetes'...
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
Checking connectivity... done.

$ cd hello-kubernetes
```

The `hello-kubernetes` project is a typical looking microservice project layout for a service written in Python. The repository contains a [Dockerfile](https://github.com/datawire/hello-kubernetes/Dockerfile), a ["Hello, world!"-esque web service](https://github.com/datawire/hello-kubernetes/hello/hello.py) implementation and directory named [`kubernetes/`](https://github.com/datawire/hello-kubernetes/kubernetes) where Kubernetes Manifests are stored. A "Manifest" is a unit of Kubernetes configuration that can be processed by `kubectl` or the Kubernetes API.

### Deployment

Once the Namespace is created and Kubernetes reports `Status: Active` we can deploy the application. If you're using Minikube from the previous tutorial then ensure your current terminal session is configured to use the Minikube Docker daemon by running the below command:

```console
$ eval $(minikube docker-env)
```

Next run `docker build` and wait for it to complete:

```console
$ docker build -t datawire/hello-kubernetes:1.0 .
```

Next we're going to create a Deployment manifest which is what Kubernetes uses to control scheduling and running your containerized service in a Pod. Create a new file `kubernetes/deployment.yaml`

```console
touch kubernetes/deployment.yaml
```

Next open the file in an editor and type into the file the following YAML which specifies a Deployment `hello-kubernetes` in the `tutorial` namespace. A deployment is a way of telling the Kubernetes scheduler enough about the thing being Deployed so that it can schedule work on Kubernetes nodes, handle upgrades and scale the underlying Pods. The below deployment will result in three running single-container Pods which means three separate instances of `hello-kubernetes` will be running.

```yaml
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: hello-kubernetes
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: hello-kubernetes
    spec:
      containers:
      - name: hello-kubernetes
        image: datawire/hello-kubernetes:1.0
        resources:
          limits:
            cpu: "0.1"
            memory: 100Mi
        ports:
        - name: http-api
          containerPort: 5000
```

Save the file and then run the below `kubectl` command to configure Kubernetes:

```console
$ kubectl apply -f kubernetes/
deployment "hello-kubernetes" created
```

The output `deployment "hello-kubernetes" created`  indicates the configuration was accepted and is being acted upon by the cluster.

You can inspect the status of the Deployment using the below `kubectl` command:

```console
$ kubectl get deployment/hello-kubernetes --namespace=tutorial

NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-kubernetes   3         3         3            3           5m
```

If the count of `Available` is equal to `3` then that means the app is successfully running, but you are probably wondering how to access the deployed application. As it stands right now there is no convenient way to talk to the running `hello-kubernetes` instances. In order to talk to them we need to create a Kubernetes Service that can route traffic to the backend pods.

### Service

Kubernetes has a resource called a "Service" which is a DNS resolvable endpoint that acts as a proxy to a set of containers. There are several types of Services in Kubernetes but for now we are going to focus solely on the `LoadBalancer` type. A `LoadBalancer` service creates a public endpoint that you can access over the public internet. The mechanism by which it does this is different depending on where your Kubernetes cluster is running, for example, on Amazon Web Services ("AWS") if you create a `LoadBalancer` then Kubernetes knows how to talk to AWS and provision an Elastic Load Balancer. However, if you are running in Minikube then Kubernetes knows it cannot create an Elastic Load Balancer and does something different.

On your computer create a new file:

```console
touch kubernetes/service.yaml
```

Next open the file in an editor and type into the file the following YAML which defines a LoadBalancer Service:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: hello-kubernetes
spec:
  type: LoadBalancer
  selector:
    app: hello-kubernetes
  ports:
  - port: 80
    targetPort: http-api
```

Once again run the now familiar `kubectl apply` command on your computer:

```console
$ kubectl apply -f kubernetes/
deployment "hello-kubernetes" configured
service "hello-kubernetes" created
```

Once you run that command Kubernetes will immediately work to fulfill the request. You can check the status of the Service with the following command, however, an important thing to know is that on Minikube the `EXTERNAL-IP` field will always be `<pending>`:

```console
$ kubectl get service/hello-kubernetes tutorial

NAME               CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
hello-kubernetes   10.0.0.162   <pending>     80:30997/TCP   2m
```

On Minikube to get the address of the service you can use the below command which will return the address:

```console
$ minikube service hello-kubernetes --url

http://192.168.99.100:30997
```

To test out your service you can combine this with something such as `curl`, for example try running the following command from a `bash` shell:

```console
while sleep 2; do curl "$(minikube service hello-kubernetes --url)"; done
```

You should see some JSON coming back from each instance of your running application. For example, given this output:

```json
{
  "hostname": "hello-kubernetes-3126827086-mtl5q",
  "message": "Hello from Kubernetes!",
  "time": "2017-06-16T18:50:41.404431"
}
{
  "hostname": "hello-kubernetes-3126827086-h66lc",
  "message": "Hello from Kubernetes!",
  "time": "2017-06-16T18:50:44.110312"
}
{
  "hostname": "hello-kubernetes-3126827086-bxrzg",
  "message": "Hello from Kubernetes!",
  "time": "2017-06-16T18:50:46.766626"
}
```

You can see that the `hostname` is changing which corresponds to the Pods running based on the earlier Deployment.

```console
$ kubectl get pods --namespace=tutorial --selector='app=hello-kubernetes'

NAME                                READY     STATUS    RESTARTS   AGE
hello-kubernetes-3126827086-bxrzg   1/1       Running   0          54m
hello-kubernetes-3126827086-h66lc   1/1       Running   0          54m
hello-kubernetes-3126827086-mtl5q   1/1       Running   0          54m
```

### Repository layout

Note that a Kubernetes service consist of three key components: the source code for a file, a `Dockerfile` that specifies how the service is containerized, and one or more Kubernetes manifest files that specify how the service is deployed.

In general, these files should all be stored in the same GitHub repository for the service. This is different from the typical monolithic repo structure, where the deployment configuration is stored in a separate repository (e.g., a Terraform directory that is maintained by operations).

Group your Kubernetes manifests (e.g. `deployment.yaml`) with your service implementation. This makes it easy to deploy later on and keeps the project configuration local to the code so they stay in sync. It also creates a convention for other services to do the same thing and allows further tooling to be layered on top.

### Self Exercises

1. What if you want to modify the number of deployed replicas of Hello Kubernetes? In `deployment.yaml` update the `replicas` field to 1 and then run `kubectl apply -f kubernetes/deployment.yaml` and see what happens.

### Takeaways

* A `Deployment` is a configuration construct that allows you to run many containers.
* A `Service` allows you to expose a `Deployment` externally.
