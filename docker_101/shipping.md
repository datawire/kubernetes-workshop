# Sharing images with others

Now that you've created an image, it's time to share it with other people.

## Tutorial

### Uploading Docker Hub

First, sign up for a [Docker Hub account](https://hub.docker.com/) or if you want you can use a shared Docker Registry that exists just for this workshop:

Then login to the registry:

If you're going to use the shared registry then the username is `datawiretraining` and password is `training2017_`

```console
$ docker login -u <USERNAME> -p <PASSWORD>
```

In the last section you tagged your image as `myhelloworld:1.0`. Most images in a registry come with a prefix, however, the name of the user or organization that created them. If you signed up as `katie123`, your images will be tagged as `katie123/<imagename>`. Rebuild your image with a new tag; don't forget to substitute your Docker Hub username for `katie123`, if you're using the shared Docker Registry then that value is `datawiretraining`.

```console
$ docker build . -t katie123/myhelloworld:$USER
```

> You can also use the `docker tag` command to add a tag to an existing image.

Now you can upload the image to the registry:

```console
$ docker push katie123/myhelloworld:$USER
```

Next, to see that it actually worked, delete the image from your local cache:

```console
$ docker rmi katie123/myhelloworld:$USER
```

It should no longer be listed in local list of images:

```console
$ docker images | grep katie123
```

The image should be retrieved from the registry when you run it:

```console
$ docker run katie123/myhelloworld:$USER Katie
```

## On your own

In the tutorial above you used the Docker Hub registry, so everything you upload is public.
Typically you'll use a registry running in your own environment for performance, and have some access control on your images.
Read up on how to run a registry in your own environment:

* [AWS Container Registry](https://aws.amazon.com/ecr/).
* [Google Container Registry](https://cloud.google.com/container-registry/)
* [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/)
* [Docker's self-hosted registry](https://docs.docker.com/registry/)
* [Quay's registry, available on-premise or as a service](https://quay.io/)

> Remember: even though many of these are called a "Container Registry", they really store *images*.

## Takeaways

* You can upload images to a registry, allowing you to share images with others.
* Your organization will need a registry for its own images.
