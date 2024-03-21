# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:edge

# Resolve DL4006 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Labels
LABEL org.opencontainers.image.authors="Thomas Deutsch <thomas@tuxpeople.org>"

# Repository pinning https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Repository_pinning
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

COPY scripts/* /scripts/

# hadolint ignore=DL3017,DL3018
RUN chmod +x /scripts/* \
    && apk add --no-cache --update \
      arping \
      bash \
      bash-completion \
      bind-libs \
      bind-tools \
      ca-certificates \
      coreutils \
      curl \
      dnsperf@testing \
      ethtool \
      fio \
      git \
      htop \
      ioping \
      iozone@testing \
      iperf \
      iperf3 \
      iproute2 \
      ipset \
      iptables \
      jq \
      kmod \
      kubectl@testing \
      less \
      lsof \
      mariadb-client \
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
      rsync \
      screen \
      socat \
      speedtest-cli \
      sslscan@testing \
      tcpdump \
      tcptraceroute \
      tmux \
      tree \
      vim \
      wget \
      which \
      yq \
    && curl -s https://fluxcd.io/install.sh | bash \
    && mkdir /workdir \
    && chmod 777 /workdir \
    && addgroup -g 1000 abc \
    && adduser -G abc -u 1000 abc -D

WORKDIR /workdir

# environment settings
ARG TZ="Europe/Zurich"
ENV PS1="\u@debugcontainer($(hostname)):\w\\$ " \
HOME="/workdir" \
TERM="xterm"

CMD ["/bin/sleep","inf"]
