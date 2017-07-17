# Running a container 

A container is an isolated process, typically a Linux process: it doesn't see other processes, it has its own networking stack, and it has its own filesystem.

## Tutorial

### Containers are isolated

On your own computer run the following four commands.
These will show you the mounted filesystems, the running processes, your network addresses, and your computer's hostname.

```console
$ df
$ ps xa
$ ifconfig
$ hostname
```

Next, you're going to run a container using the Docker command-line tool.
In particular, you're going to start a new shell inside a container running Alpine Linux, a Linux distribution like Ubuntu or CentOS.
Once the new shell starts, type those four commands again:

```console
$ docker run --interactive --tty alpine /bin/sh
alpine# df
alpine# ps xa
alpine# ifconfig
alpine# hostname
alpine# exit
$
```

> On some versions of Linux running `docker` requires root: the command above will fail with a "permission denied" error.
> If that happens you'll need to run `docker` with `sudo`, both here and in later examples that run `docker`:
>
> ```console
> $ sudo docker run --interactive --tty alpine /bin/sh
> ```

Compare the output in your own terminal to the output from the container, and you'll notice that inside the container you have:

1. Different mounted filesystems.
2. Different processes running: only `ps` and `/bin/sh`, in fact.
3. Different network addresses.
4. A different hostname.

### Containers start quickly

In addition to being isolated, the container will also start up as quickly as a normal process.
The first time you ran that command Docker needed to download Alpine Linux, which can take some time.
Now that you've got Alpine cached locally, try running another container:

```
$ docker run --interactive --tty alpine /bin/sh
/ # echo hello world
/ # exit
$
```

You'll notice this time it starts up just as fast as a normal process would.

### Each container has its own filesystem

Start a container and write some data to a file:

```console
$ docker run -i -t alpine /bin/sh
# / echo hello > /tmp/hello.txt
# / cat /tmp/hello.txt
# / exit
```

Now on your main terminal check if `/tmp/hello.txt` exists.
Then start a new container, and check if `/tmp/hello.txt` exists.

## On your own

You can pass command line arguments to the process the container runs:

```console
$ docker run -i -t alpine echo hello world
```

Set environment variables:

```console
$ docker run -i -t -e HELLO=world alpine /bin/sh
```

Mount a directory from your machine into the container:

```console
$ docker run -i -t -v $PWD:/host alpine ls /host
```

Play around with these options, and see if you understand what they do.
You can also look at the options described in the [docker run documentation](https://docs.docker.com/engine/reference/run/) to see more ways you can control the container.

## Takeaways

* You can use `docker run` to run a container.
* A container lets you quickly start an isolated Linux process with its own filesystem and networking stack.
* A container starts with a copy of the base filesystem: changes in one container don't affect other containers.

Next we'll talk about where this filesystem comes from and how you can create one.
