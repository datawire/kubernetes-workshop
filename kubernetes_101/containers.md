# Running a Container

Kubernetes is all about running containers. In this section you will learn how to run a a very simple container that gives you shell access on the Kubernetes cluster which is useful for understanding some Kubernetes basics.

## Running an interactive console terminal on the cluster

On your computer run the following command using the `kubectl` command line tool. In particular, you're going to start a new shell inside a container running Alpine Linux just like you did in the earlier Docker tutorial [Running a Container](../containers/containers.md).

```console
$ kubectl run my-shell --rm -i --tty --image alpine -- /bin/sh
If you don't see a command prompt, try pressing enter.

# / df
# / ps xa
# / ifconfig
# / hostname
```

In another terminal run command `kubectl run my-other-shell --rm -i --tty --image alpine -- /bin/sh` command again.

Compare the output from the container in the first terminal to the output from the container in the second terminal, and you'll notice that inside the container you have:

1. Different mounted filesystems.
2. Different processes running (check the PIDs because the same process names will be present).
3. Different network addresses.
4. A different hostname.

To exit the container you run the `exit` command:

```console
# / exit
Session ended, resume using 'kubectl attach my-shell-ABC -c my-shell -i -t' command when the pod is running
$
```

### On your own

You can run different operating systems (do not forget that it takes a while to pull the image the first time from a remote Docker Registry). 

```console
$ kubectl run my-os --rm -i --tty --image ubuntu -- /bin/bash
```

Set some environment variables:

```console
$ kubectl run vars --rm -i --tty --env FOOBAR=BAZBOT,DATAWIRE=ROCKS --image ubuntu -- /bin/bash
```

## Takeaway

1. Containers on Kubernetes are isolated processes within the cluster.
2. You can use `kubectl run ...` to start an interactive session on the cluster.
