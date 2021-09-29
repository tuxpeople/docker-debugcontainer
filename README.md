# Debugcontainer
![Github Workflow Badge](https://github.com/tuxpeople/docker-debugcontainer/actions/workflows/release.yml/badge.svg)
![Github Last Commit Badge](https://img.shields.io/github/last-commit/tuxpeople/docker-debugcontainer)
![Docker Pull Badge](https://img.shields.io/docker/pulls/tdeutsch/debugcontainer)
![Docker Stars Badge](https://img.shields.io/docker/stars/tdeutsch/debugcontainer)
![Docker Size Badge](https://img.shields.io/docker/image-size/tdeutsch/debugcontainer)

## Quick reference

I made this container to debug container infrastructure (eg. Kubernetes). 
This is a image with many handy tools in it.

* **Code repository:**
  https://github.com/tuxpeople/docker-debugcontainer
* **Where to file issues:**
  https://github.com/tuxpeople/docker-debugcontainer/issues
* **Supported architectures:**
  ```amd64```, ```armv7``` and ```arm64```

## Image tags
- ```latest``` always refers to the latest tagged release.
- There are tags for major, minor and dotreleases (eg. ```1.0.0```, ```1.0```, ```1``` )
- ```nightly``` gets automatically built a daily cron job

## Usage
You can either deploy this container standalone to test stuff, or use it as a side car if you need some special features in your pod. One use case as a side car is analyse traffic with tcpdump.

```sh
docker pull tdeutsch/debugcontainer:<tag>
```

or

```sh
docker pull ghcr.io/tuxpeople/debugcontainer:<tag>
```


or

```sh
docker pull quay.io/tdeutsch/debugcontainer:<tag>
```
