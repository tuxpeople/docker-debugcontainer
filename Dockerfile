# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:3.23.0

# Resolve DL4006 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Labels
LABEL org.opencontainers.image.authors="Thomas Deutsch <thomas@tuxpeople.org>" \
      org.opencontainers.image.description="Debug container with networking and troubleshooting tools"

# Tool versions (managed by Renovate)
ARG FLUX_VERSION=2.7.5
ARG CARVEL_YTT_VERSION=0.52.2
ARG CARVEL_IMGPKG_VERSION=0.47.0
ARG ORAS_VERSION=1.3.0

COPY scripts/* /scripts/
COPY requirements.txt /requirements.txt

# hadolint ignore=DL3017,DL3018,DL3013
RUN chmod +x /scripts/* \
  && apk --update upgrade \
  && apk add --no-cache --update \
  --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
  --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  arping \
  bash \
  bash-completion \
  bind-libs \
  bind-tools \
  ca-certificates \
  coreutils \
  curl \
  crane \
  dnsperf \
  ethtool \
  fio \
  git \
  hdparm \
  htop \
  ioping \
  iozone \
  iperf \
  iperf3 \
  iproute2 \
  ipset \
  iptables \
  jq \
  kmod \
  kubectl \
  less \
  lsof \
  mariadb-client \
  mariadb-connector-c \
  mc \
  minio-client \
  mtr \
  multitail \
  net-tools \
  netcat-openbsd \
  nfs-utils \
  ngrep \
  nmap \
  openssh \
  openssh-client \
  openssl \
  p7zip \
  parallel \
  perl-utils \
  psmisc \
  py3-pip \
  rsync \
  screen \
  socat \
  speedtest-cli \
  sslscan \
  tcpdump \
  tcptraceroute \
  inetutils-telnet \
  tmux \
  tree \
  vim \
  wget \
  which \
  yq \
  && OS="$(uname -s | tr A-Z a-z)" \
  && ARCH="$(uname -m | sed -e 's/x86_64/amd64/g' -e 's/aarch64/arm64/g')" \
  && curl -sL "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_${OS}_${ARCH}.tar.gz" | tar xz -C /usr/local/bin \
  && curl -sL "https://github.com/carvel-dev/ytt/releases/download/v${CARVEL_YTT_VERSION}/ytt-${OS}-${ARCH}" -o /usr/local/bin/ytt \
  && curl -sL "https://github.com/carvel-dev/imgpkg/releases/download/v${CARVEL_IMGPKG_VERSION}/imgpkg-${OS}-${ARCH}" -o /usr/local/bin/imgpkg \
  && chmod +x /usr/local/bin/ytt /usr/local/bin/imgpkg \
  && curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_${OS}_${ARCH}.tar.gz" \
  && mkdir -p oras-install/ \
  && tar -zxf "oras_${ORAS_VERSION#v}_${OS}_${ARCH}.tar.gz" -C oras-install/ \
  && mv oras-install/oras /usr/local/bin/ \
  && rm -rf "oras_${ORAS_VERSION}_${OS}_${ARCH}.tar.gz" oras-install/ \
  && oras completion bash > /etc/bash_completion.d/oras \
  && echo "v${ORAS_VERSION}" > /etc/oras-version \
  && echo "v${FLUX_VERSION}" > /etc/flux-version \
  && echo "v${CARVEL_YTT_VERSION}" > /etc/ytt-version \
  && echo "v${CARVEL_IMGPKG_VERSION}" > /etc/imgpkg-version \
  && apk add --no-cache --virtual .build-deps musl-dev python3-dev libffi-dev openssl-dev cargo make \
  && pip install --break-system-packages --no-cache-dir --upgrade pip \
  && pip install --break-system-packages --no-cache-dir --requirement /requirements.txt \
  && apk del .build-deps \
  && rm -f /requirements.txt \
  && crane completion bash > /etc/bash_completion.d/crane \
  && mkdir /workdir \
  && chmod 755 /workdir \
  && addgroup -g 1000 abc \
  && adduser -G abc -u 1000 abc -D \
  && rm -rf /var/cache/apk/*

WORKDIR /workdir

# Pinned tool versions are stored in /etc/ for runtime inspection
# - /etc/oras-version: ORAS CLI version
# - /etc/flux-version: Flux CLI version
# - /etc/ytt-version: Carvel ytt version
# - /etc/imgpkg-version: Carvel imgpkg version

# environment settings
ENV PS1="\u@debugcontainer($(hostname)):\w\\$ " \
  HOME="/workdir" \
  TERM="xterm" \
  TZ="Europe/Zurich"

CMD ["/bin/sleep","inf"]
