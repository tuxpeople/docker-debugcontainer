# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:3.14.2

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
    && apk upgrade --no-cache \
    && apk add --no-cache \
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
      k9s \
      lsof \
      mariadb-client \
      mc \
      minio-client@testing \
      mtr \
      net-tools \
      netcat-openbsd \
      nfs-utils \
      nmap \
      openssh-client \
      openssl \
      p7zip \
      screen \
      socat \
      sslscan@testing \
      tcpdump \
      tcptraceroute \
      tmux \
      tree \
      vim \
      wget \
      which \
      yq \
    && wget -q -O /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli \
    && mkdir /workdir \
    && chmod 777 /workdir

WORKDIR /workdir

# environment settings
ARG TZ="Europe/Zurich"
ENV PS1="\u@debugcontainer($(hostname)):\w\\$ " \
HOME="/workdir" \
TERM="xterm"

CMD ["/bin/sleep","inf"]