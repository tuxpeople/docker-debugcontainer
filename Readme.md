# Debugcontainer
## Quick reference

I made this container to debug container infrastructure (eg. Kubernetes). 
This is a image with many handy tools in it.

* **Code repository:**
  https://github.com/tuxpeople/docker-debugcontainer
* **Where to file issues:**
  https://github.com/tuxpeople/docker-debugcontainer/issues
* **Maintained by:**
  ["tuxpeople"](https://github.com/tuxpeople)
* **Supported architectures:**
  ```amd64```, ```armv7```, ```armv6``` and ```arm64```

## Image tags
- ```latest``` always refers to the latest tagged release ([Dockerfile])(https://github.com/tuxpeople/docker-debugcontainer/blob/master/Dockerfile)
- There are tags for major, minor and dotreleases (eg. ```1.0.0```, ```1.0```, ```1``` )
- ```edge``` gets automatically built on every push to master and also via a weekly cron job

## Usage
You can either deploy this container standalone to test stuff, or use it as a side car if you need some special features in your pod. One use case as a side car is analyse traffic with tcpdump.

## Bages ;-)
![Github Workflow Badge](https://github.com/tuxpeople/docker-debugcontainer/actions/workflows/ci/badge.svg)

## Notice about Docker Hub
Due to the new rate limits on Docker Hub, I decided to give the images a new home at quay.io. Therefore, quay.io is the prefered source to pull this image:

```sh
docker pull quay.io/tdeutsch/debugcontainer:<tag>
```

Althought the CI/CD Pipeline will also update the images at Docker Hub, please consider Docker Hub as deprecated.