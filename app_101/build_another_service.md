# Connecting Your First Service to Another Service

Microservice applications are composed of many cooperatively communicating services. In this section you will learn how easy it is to connect one service to another. We will use the Hello Kubernetes service from the previous tutorial about Building and Running your First Service to another new Service that runs in the same Kubernetes cluster.

## The New Service

The new service is the [Quote of The Moment Service](https://github.com/datawire/qotm) and the job of the service is to return a random, somewhat strange sounding unattributed quote when a client sends a request.

On your computer open a new Terminal and then clone the [`datawire/qotm`](https://github.com/datawire/qotm) Git repository:

```console
$ git clone https://github.com/datawire/qotm.git
Cloning into 'qotm'...
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
Checking connectivity... done.

$ cd qotm
```

The layout of the Quote service should be familiar as it the same as `hello-kubernetes` with the [`Dockerfile`](https://github.com/datawire/qotm/Dockerfile) sitting in the project's root directory and a [`kubernetes/`](https://github.com/datawire/qotm/kubernetes)` directory with Kubernetes manifests.

Display the `kubernetes/service.yaml` file in your console with the below command:

```console
cat kubernetes/service.yaml

---
apiVersion: v1
kind: Service
metadata:
  name: qotm
  namespace: tutorial
spec:
  type: ClusterIP
  selector:
    app: qotm
  ports:
  - port: 80
    targetPort: http-api
```

The most important piece of information in the QOTM Kubernetes Service manifest is the `type: ClusterIP`. In the Hello Kubernetes tutorial you saw a `type: LoadBalancer` service which exposed an external IP address to access the Hello Kubernetes pods. Kubernetes has several several different types of Services and one of the most common is `ClusterIP`. The `ClusterIP` type creates a service that does not have an external IP address which means the service can only be accessed from inside of the cluster. The `ClusterIP` service type is extremely common for backend services which do not need to be accessed in any way except from other consumers in the same cluster. 

To deploy the Quote service run the familiar `kubectl apply` command on your computer:

```console
$ kubectl apply -f kubernetes/
deployment "qotm" created
service "qotm" created
```

Once you run that command Kubernetes will immediately work to fulfill the request. You can check the status of the Service with the following command:

```console
$ kubectl get service/qotm --namespace tutorial

NAME   CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
qotm   10.0.0.46    <none>        80:30997/TCP   2m
```

Kubernetes did not assign an externally accessible address because of the `ClusterIP` type and that is exactly the outcome we want because QOTM is intended to be used as backend service for the previous Hello Kubernetes application and should not be exposed outside of the cluster.

For the next few steps open another command line terminal then enter into the directory where you cloned Hello Kubernetes.

```console
cd hello-kubernetes
```

Update the code to talk to the Quote service. In an editor open the [`hello/hello.py`](https://github.com/datawire/hello-kubernetes/hello/hello.py) and find this section of code:

```python
#@app.route("/quote", methods=["GET"])
#def hello_with_quote():
#    import urllib.request
#    import json
#
#    res = urllib.request.urlopen("http://qotm.tutorial")
#    data = res.read()
#
#    return jsonify(message="Hello from Kubernetes!",
#                   quote=json.loads(data.decode('utf-8')),
#                   hostname=os.getenv("HOSTNAME"),
#                   time=datetime.datetime.now().isoformat())
```

Open the file in an editor and remove the comment (`#`) characters and save the updated file. The resulting code block should appear as below:

```python
@app.route("/quote", methods=["GET"])
def hello_with_quote():
    import urllib.request
    import json

    res = urllib.request.urlopen("http://qotm.tutorial")
    data = res.read()

    return jsonify(message="Hello from Kubernetes!",
                   quote=json.loads(data.decode('utf-8')),
                   hostname=os.getenv("HOSTNAME"),
                   time=datetime.datetime.now().isoformat())
```

Run a quick sanity check to ensure the Python source code is syntactically valid. If the below command complains of an error then fix any issues it finds:

```console
$ python -m py_compile hello/hello.py
```

## Communicating with the New Service

In the new `/quote` URL implementation you just wrote the method call `urllib.request.urlopen("http://qotm.tutorial")` points at the Kubernetes Service of the Quote service. This is the beauty of Kubernetes, it uses an internal DNS server to handle service discovery for your applications. You can refer to the previously deployed QOTM service by attempting to connect to a named host. In Kubernetes discovering services is as simple as referring to them by `${SERVICE_NAME}.${NAMESPACE}` because there is a built-in DNS service in Kubernetes.

Time to deploy then test out the new functionality. If you are using Minikube from the previous tutorial then ensure your current terminal session is configured to use the Minikube Docker daemon by running the below command and then following the instructions it gives:

```console
$ minikube docker-env
```

Next rebuild the Docker image for the modified Hello Kubernetes service.

```console
$ docker build -t datawire/hello-kubernetes:1.1 .
```

Afterwards open the Hello Kubernetes deployment manifest and find the line `image: datawire/hello-kubernetes:1.0`. Update the line to refer to be `image: datawire/hello-kubernetes:1.1`.

Finally save the file and then run `kubectl apply`:

```console
$ kubectl apply kubernetes/

deployment "hello-kubernetes" configured
namespace "tutorial" configured
resourcequota "quota" configured
service "hello-kubernetes" configured
```

To test out your Hello Kubernetes service that communicates with the Quote service run the below command for a few seconds:
exposes

```console
while sleep 2; do curl "$(minikube service hello-kubernetes --namespace=tutorial --url)/quote"; done
```

You should see some JSON coming back from each instance of your running Hello Kubernetes service. For example:

```json
{
  "hostname": "hello-kubernetes-3491141713-msc3t", 
  "message": "Hello from Kubernetes!", 
  "quote": {
    "hostname": "qotm-1631226406-tj6p7", 
    "quote": "Utter nonsense is a storyteller without equal.", 
    "time": "2017-06-18T18:24:10.579112"
  }, 
  "time": "2017-06-18T18:24:10.580527"
}
{
  "hostname": "hello-kubernetes-3491141713-64nrl", 
  "message": "Hello from Kubernetes!", 
  "quote": {
    "hostname": "qotm-1631226406-htmss", 
    "quote": "The light at the end of the tunnel is interdependent on the relatedness of motivation, subcultures, and management.", 
    "time": "2017-06-18T18:24:13.279567"
  }, 
  "time": "2017-06-18T18:24:13.281349"
}
{
  "hostname": "hello-kubernetes-3491141713-64nrl", 
  "message": "Hello from Kubernetes!", 
  "quote": {
    "hostname": "qotm-1631226406-fwsjc", 
    "quote": "Nihilism gambles with lives, happiness, and even destiny itself!", 
    "time": "2017-06-18T18:24:16.178457"
  }, 
  "time": "2017-06-18T18:24:16.179807"
}
```

The code in your Hello Kubernetes application is invoking the HTTP endpoint on the Quote service to get a random quote.

## Takeaways

* There are different types of Kubernetes services. You have seen `LoadBalancer` and `ClusterIP` which are the two you are most likely to encounter. A `LoadBalancer` service assigns and exposes an external address while a `ClusterIP` only assigns an internal address and ensures only consumers inside the cluster can reach the Pods behind the service.

* The Kubernetes Service construct is powerful. One of the most powerful features is that it creates a stable DNS name for all of your backend Pods so that you do not need to run an additional service discovery component inside of Kubernetes.

* A `Deployment` in Kubernetes is a powerful construct that allows the cluster scheduler to safely upgrade Pods using a `RollingUpdate` strategy where new instances of the app are slowly started before older versions are removed.
