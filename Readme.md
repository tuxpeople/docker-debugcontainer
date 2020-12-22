# Debugcontainer

I made this container to debug container infrastructure (eg. Kubernetes). This is a image with many handy tools in it.

## Notice about Docker Hub

Due to the new rate limits on Docker Hub, I decided to give the images a new home at quay.io. Therefore, quay.io is the prefered source to pull this image:

```sh
docker pull quay.io/tdeutsch/debugcontainer:<tag>
```

Althought the CI/CD Pipeline will also update the images at Docker Hub, please consider Docker Hub as deprecated.