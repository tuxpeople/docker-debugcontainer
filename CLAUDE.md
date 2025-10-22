# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker debugging container designed for troubleshooting container infrastructure, particularly in Kubernetes environments. It's based on Alpine Linux and bundles numerous networking, debugging, and performance testing tools into a single image. The container supports both `amd64` and `arm64` architectures and is published to both Docker Hub (`tdeutsch/debugcontainer`) and GitHub Container Registry (`ghcr.io/tuxpeople/debugcontainer`).

## Building and Testing

### Build the Docker Image Locally
```bash
docker build -t debugcontainer:local .
```

### Build for Multiple Platforms
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t debugcontainer:local .
```

### Run Hadolint (Dockerfile Linting)
This project uses Hadolint to ensure Dockerfile best practices. To run locally:
```bash
docker run --rm -i hadolint/hadolint < Dockerfile
```

### Test the Container Locally
```bash
docker run -it --rm debugcontainer:local /bin/bash
```

## CI/CD Pipeline

The project uses GitHub Actions with three key workflows:

1. **Pull Requests** (`.github/workflows/pullrequests.yml`): Runs Hadolint linting and builds for `linux/amd64`, `linux/arm/v7`, and `linux/arm64` platforms
2. **Build & Release** (`.github/workflows/release.yml`): Triggered on releases, daily cron, or pushes to master/main. Builds, tags, and pushes to both Docker Hub and GHCR
3. **Auto-assign Issues** (`.github/workflows/auto-assign-issues.yaml`): Automatically assigns issues

### Image Tagging Strategy
- `latest`: Most recent tagged release
- `nightly`: Daily automated builds via cron job
- `devel`: Latest version from master/main branch
- Semantic versioning: `x.y.z`, `x.y`, and `x` tags for releases

## Repository Structure

### Key Files
- **Dockerfile**: Single-stage Alpine-based image that installs all debugging tools
- **requirements.txt**: Python packages (currently only `azure-cli`)
- **scripts/hdd-perf.sh**: Storage performance testing script using dd, fio, ioping, and iozone
- **renovate.json**: Renovate bot configuration with automerge enabled for all updates

### Installed Tools
The container includes 60+ tools across several categories:
- **Networking**: tcpdump, nmap, mtr, iperf3, netcat, socat, arping, ethtool, tcptraceroute, ngrep
- **DNS**: bind-tools, dnsperf
- **Container/Kubernetes**: kubectl, crane (for container registry operations), flux, ytt, imgpkg (Carvel tools)
- **Database**: mariadb-client, mssql-tools
- **Storage**: minio-client, nfs-utils
- **Performance**: fio, hdparm, ioping, iozone, speedtest-cli
- **General utilities**: bash, curl, wget, jq, yq, vim, git, screen, tmux, htop, lsof, rsync

## Dockerfile Architecture

The Dockerfile uses a single-stage build with these key steps:
1. Base image: Alpine 3.22.1
2. Copies scripts and requirements.txt
3. Installs all APK packages from edge repositories (main, community, testing)
4. Installs flux CLI via shell script
5. Installs select Carvel tools (ytt, imgpkg) while removing others (kapp, kbld, kwt, vendir)
6. Uses virtual build dependencies for Python packages, then removes them to reduce image size
7. Creates a non-root user `abc` (uid/gid 1000)
8. Sets up bash completion for crane
9. Default command: `/bin/sleep inf` (keeps container running indefinitely)

## Modifying Dependencies

### Adding Alpine Packages
Edit the Dockerfile's `apk add` section (lines 21-84). Packages are installed from edge repositories to get latest versions.

### Adding Python Packages
Add to `requirements.txt`. Note the use of `--break-system-packages` flag since Alpine uses system-managed Python.

### Adding Scripts
Place new scripts in the `scripts/` directory. They will be copied to `/scripts/` in the container and made executable.

## Dependency Management

Renovate is configured to automatically update dependencies with automerge enabled for all updates, including patch versions. The configuration ensures fast dependency updates without manual intervention.
