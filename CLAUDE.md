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

1. **Pull Requests** (`.github/workflows/pullrequests.yml`): Runs Hadolint linting and builds for `linux/amd64` and `linux/arm64` platforms
2. **Build & Release** (`.github/workflows/release.yml`): Triggered on releases, daily cron, or pushes to master/main. Builds, tags, and pushes to both Docker Hub and GHCR
3. **Auto-assign Issues** (`.github/workflows/auto-assign-issues.yaml`): Automatically assigns issues

### Image Tagging Strategy
- `latest`: Most recent tagged release
- `nightly`: Daily automated builds via cron job
- `devel`: Latest version from master/main branch
- Semantic versioning: `x.y.z`, `x.y`, and `x` tags for releases

### Automatic Versioning and Releases

The project uses `mathieudutour/github-tag-action` to automatically create version tags and releases based on commit messages. **All commits MUST follow the Conventional Commits format:**

- `feat:` - New features (triggers **minor** version bump, e.g., 1.0.0 → 1.1.0)
- `fix:` - Bug fixes (triggers **patch** version bump, e.g., 1.0.0 → 1.0.1)
- `chore:` - Maintenance tasks (no version bump)
- `refactor:` - Code refactoring (no version bump)
- `docs:` - Documentation changes (no version bump)
- `BREAKING CHANGE:` in commit body or `feat!:`/`fix!:` - Breaking changes (triggers **major** version bump, e.g., 1.0.0 → 2.0.0)

**Important**: Since `default_bump: false` is set in the workflow, commits **without** conventional commit prefixes will NOT trigger a new release. Only properly formatted commits will create new versions.

**Examples:**
```bash
git commit -m "feat: add new debugging tool"        # Creates minor version
git commit -m "fix: correct network configuration"  # Creates patch version
git commit -m "chore: update dependencies"          # No new version
```

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
- **Container/Kubernetes**: kubectl, crane (for container registry operations), flux, ytt, imgpkg (Carvel tools), oras (OCI registry client)
- **Database**: mariadb-client, mssql-tools
- **Storage**: minio-client, nfs-utils
- **Performance**: fio, hdparm, ioping, iozone, speedtest-cli
- **General utilities**: bash, curl, wget, jq, yq, vim, git, screen, tmux, htop, lsof, rsync

### Pinned Tool Versions
Key tools have pinned versions managed by Renovate:
- **ORAS**: Version pinned via `ARG ORAS_VERSION` in Dockerfile. Version stored in `/etc/oras-version`
- **Flux**: Version pinned via `ARG FLUX_VERSION` in Dockerfile. Version stored in `/etc/flux-version`
- **Carvel ytt**: Version pinned via `ARG CARVEL_YTT_VERSION` in Dockerfile. Version stored in `/etc/ytt-version`
- **Carvel imgpkg**: Version pinned via `ARG CARVEL_IMGPKG_VERSION` in Dockerfile. Version stored in `/etc/imgpkg-version`

Renovate automatically creates PRs when new versions are released. All version files can be inspected at runtime in `/etc/`.

## Dockerfile Architecture

The Dockerfile uses a single-stage build with these key steps:
1. Base image: Alpine 3.22.2
2. Copies scripts and requirements.txt
3. Installs all APK packages from edge repositories (main, community, testing)
4. Installs flux CLI via shell script
5. Installs select Carvel tools (ytt, imgpkg) while removing others (kapp, kbld, kwt, vendir)
6. Installs ORAS from latest GitHub release with error handling and fallback
7. Sets up bash completion for crane and oras
8. Uses virtual build dependencies for Python packages, then removes them to reduce image size
9. Creates a non-root user `abc` (uid/gid 1000)
10. Stores dynamic tool versions in `/etc/` for runtime inspection
11. Default command: `/bin/sleep inf` (keeps container running indefinitely)

## Modifying Dependencies

### Adding Alpine Packages
Edit the Dockerfile's `apk add` section (lines 21-84). Packages are installed from edge repositories to get latest versions.

### Adding Python Packages
Add to `requirements.txt`. Note the use of `--break-system-packages` flag since Alpine uses system-managed Python.

### Adding Scripts
Place new scripts in the `scripts/` directory. They will be copied to `/scripts/` in the container and made executable.

### Adding Dynamically Installed Tools
When adding tools that are installed from GitHub releases or external sources:
1. Add installation logic in the main RUN command (after Carvel tools, before Python packages)
2. Use error handling with fallback versions (see ORAS installation as example)
3. Store the installed version in `/etc/<tool>-version` for traceability
4. Add bash completion if supported: `<tool> completion bash > /etc/bash_completion.d/<tool>`
5. Update this CLAUDE.md file to document the new tool

## Dependency Management

Renovate is configured to automatically update dependencies with automerge enabled for all updates, including patch versions. The configuration ensures fast dependency updates without manual intervention.

### Pinned Tool Updates via Renovate

The following tools are version-pinned in the Dockerfile and automatically updated by Renovate:
- **Flux CLI** (`fluxcd/flux2`)
- **ORAS** (`oras-project/oras`)
- **Carvel ytt** (`carvel-dev/ytt`)
- **Carvel imgpkg** (`carvel-dev/imgpkg`)

Renovate uses regex managers to detect version updates in the Dockerfile `ARG` statements and creates PRs with changelogs when new versions are released. This provides:
- Clear visibility of tool version changes in git history
- Automatic changelog generation from GitHub releases
- Ability to review and test updates before merging
- Reproducible builds with locked versions

## Important Notes

- **Platform Support**: The container builds for `linux/amd64` and `linux/arm64` only. Both PR and release workflows must use identical platform lists.
- **Bash Completion**: Tools with bash completion support should have their completions installed in `/etc/bash_completion.d/`
- **Error Handling**: Dynamic installations from external sources should include error handling and fallback versions to prevent build failures
