# Debugcontainer

![Github Workflow Badge](https://github.com/tuxpeople/docker-debugcontainer/actions/workflows/release.yml/badge.svg)
![Github Last Commit Badge](https://img.shields.io/github/last-commit/tuxpeople/docker-debugcontainer)
![Docker Pull Badge](https://img.shields.io/docker/pulls/tdeutsch/debugcontainer)
![Docker Stars Badge](https://img.shields.io/docker/stars/tdeutsch/debugcontainer)
![Docker Size Badge](https://img.shields.io/docker/image-size/tdeutsch/debugcontainer)

A comprehensive debugging container built on Alpine Linux, packed with 60+ networking, performance testing, and troubleshooting tools for debugging container infrastructure, especially Kubernetes environments.

## Quick Reference

* **Code repository:** https://github.com/tuxpeople/docker-debugcontainer
* **Where to file issues:** https://github.com/tuxpeople/docker-debugcontainer/issues
* **Supported architectures:** `amd64` and `arm64`
* **Base image:** Alpine Linux 3.22.2

## Image Tags

- `latest` - Latest tagged release
- `x.y.z`, `x.y`, `x` - Semantic version tags (e.g., `1.0.0`, `1.0`, `1`)
- `nightly` - Automatically built by daily cron job
- `devel` - Latest version from master branch (built on every push)

## Available from Multiple Registries

```bash
# Docker Hub
docker pull tdeutsch/debugcontainer:latest

# GitHub Container Registry
docker pull ghcr.io/tuxpeople/debugcontainer:latest
```

## Included Tools

### Networking & Diagnostics
`tcpdump`, `nmap`, `mtr`, `iperf3`, `netcat`, `socat`, `arping`, `ethtool`, `tcptraceroute`, `ngrep`, `bind-tools`, `dnsperf`, `sslscan`

### Container & Kubernetes
`kubectl`, `crane`, `flux`, `ytt`, `imgpkg`, `oras`

### Database Clients
`mariadb-client`, `azure-cli`

### Storage & File Systems
`minio-client`, `nfs-utils`, `rsync`

### Performance Testing
`fio`, `hdparm`, `ioping`, `iozone`, `speedtest-cli`

### General Utilities
`bash`, `curl`, `wget`, `jq`, `yq`, `vim`, `git`, `screen`, `tmux`, `htop`, `lsof`, `tree`, `mc`, `p7zip`

## Usage Examples

### Quick Debug Session

Start an interactive shell in a running Kubernetes pod:

```bash
kubectl run debugcontainer --rm -it --image=tdeutsch/debugcontainer:latest -- /bin/bash
```

### Network Troubleshooting

Test connectivity and DNS resolution:

```bash
# Run container with network debugging
docker run -it --rm tdeutsch/debugcontainer:latest /bin/bash

# Inside container - test DNS
nslookup example.com
dig example.com

# Test connectivity
ping -c 3 8.8.8.8
mtr google.com

# Port scanning
nmap -p 80,443 example.com

# Bandwidth testing
iperf3 -c iperf.example.com
```

### Packet Capture as Sidecar

Deploy as a sidecar to capture traffic from another container:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debug
spec:
  containers:
  - name: app
    image: your-app:latest
  - name: debugger
    image: tdeutsch/debugcontainer:latest
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "NET_RAW"]
    command: ["/bin/sleep", "inf"]
```

Then exec into the sidecar and capture traffic:

```bash
kubectl exec -it app-with-debug -c debugger -- tcpdump -i any -w /tmp/capture.pcap
```

### Storage Performance Testing

Test disk I/O performance:

```bash
docker run -it --rm -v /path/to/test:/workdir tdeutsch/debugcontainer:latest /bin/bash

# Inside container
cd /workdir
/scripts/hdd-perf.sh
```

### OCI Registry Operations

Work with container registries using ORAS:

```bash
docker run -it --rm tdeutsch/debugcontainer:latest /bin/bash

# Push artifact to registry
oras push myregistry.io/myartifact:v1 ./file.txt

# Pull artifact
oras pull myregistry.io/myartifact:v1

# Check ORAS version
cat /etc/oras-version
```

### Database Connection Testing

```bash
docker run -it --rm tdeutsch/debugcontainer:latest /bin/bash

# Test MySQL/MariaDB connection
mysql -h database.example.com -u user -p

# Azure CLI operations
az login
az account list
```

## Use Cases

- **Kubernetes Debugging**: Deploy as a troubleshooting pod to diagnose cluster issues
- **Network Analysis**: Capture and analyze traffic between services
- **Performance Testing**: Benchmark storage, network, and compute resources
- **Sidecar Diagnostics**: Run alongside application containers to debug without modifying the app image
- **CI/CD Testing**: Use in pipelines to verify connectivity and services
- **Learning Tool**: Experiment with various DevOps and networking tools in an isolated environment

## Building Locally

```bash
# Build for local platform
docker build -t debugcontainer:local .

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t debugcontainer:local .
```

## Contributing

Contributions are welcome! Please open an issue or pull request on GitHub.

**Note:** This project uses conventional commits for automatic versioning. Commit messages must follow the format:
- `feat:` for new features (minor version bump)
- `fix:` for bug fixes (patch version bump)
- `chore:`, `docs:`, `refactor:` for non-release changes

## License

See the [LICENSE](LICENSE) file for details.
