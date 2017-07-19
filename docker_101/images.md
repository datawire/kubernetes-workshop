# Packaging an application in an image

Whenever a new container is created, its filesystem is initialized from an *image*.
In previous section you were using the `alpine` image which contains all the files necessary to run Alpine Linux.

## Tutorial

### Browsing local images

To see which images are available locally on your machine, run:

```console
$ docker images
```

> Remember, if you get a "permission denied" error you'll want to run `sudo docker images` instead.

### Where images come from

When you ran `docker run alpine` Docker checked if the image was available locally.
If it wasn't available locally, Docker will download the from a remote *image registry*.
The default image registry is the [Docker Hub](https://hub.docker.com), which has many pre-existing images available.

Each image has a page - visit [the page for the `alpine` image](https://hub.docker.com/_/alpine/) and see what you can learn.

### Tags: different versions of images

If you click on the "Tags" tab in the [the page for the `alpine` image](https://hub.docker.com/_/alpine/) you'll see a list of tags.
Each tag is a different version of the image.

When you do `docker run` you can specify a particular version of the image to load.
For example, here you download and then run version 3.3 of the `alpine` image:

```console
$ docker run alpine:3.3 cat /etc/alpine-release
```

If you don't specify a tag then `latest` is used:

```console
$ docker run alpine:latest cat /etc/alpine-release
$ docker run alpine cat /etc/alpine-release
```

> A tag can point to different images over time.
> That means your locally cached `latest` may be different than the `latest` in the image registry.

## Creating your own image

You can create your own images, and almost always you'll want to base your images on an existing one.
Most Linux distributions provide base images on the Docker Hub, so you can use Ubuntu or CentOS as base images.
We'll be building on the `alpine` image because it produces smaller images, and also allows you to build new images faster.

In a new directory create a file called `helloworld.py` with the following contents:

```python
#!/usr/bin/env python3

import sys

print("Hello", sys.argv[1])
```

and in the same directory create a file called `Dockerfile` with the following contents:

```dockerfile
FROM alpine:3.6
# Run a command inside the container as we build.
# In this case, install python 3:
RUN apk add --no-cache python3
# Copy a file from the host machine's filesystem to the new image:
COPY helloworld.py /root
# Run another command:
RUN chmod +x /root/helloworld.py
# Set the default command to run when a new container is started with this image;
# additional command-line arguments will be passed to it:
ENTRYPOINT ["/root/helloworld.py"]
```

You can now build a new image, let's called it `myhelloworld`:

```console
$ docker build . -t myhelloworld:1.0
```

You should be able to see the image when you list images:

```console
$ docker images | grep myhelloworld
```

And you can now run new containers using this image:

```console
$ docker run myhelloworld:1.0 Alice
```

## On your own

1. Take a look at the [official image repositories](https://hub.docker.com/explore/) available on the Docker Hub.
2. Skim the documentation for the [Dockerfile format](https://docs.docker.com/engine/reference/builder/).
3. Try to package a small program in your programming language of choice.

## Takeaways

* Images initialize the filesystem used by a container.
* Images have different versions, addressable using tags.
* Images can be built on top of other images.
* Images can be stored locally or retrieved from a remote registry.
* You can create images using a `Dockerfile` and `docker build`.

Next we'll see how you can share your images with others, by uploading them to the image registry.
