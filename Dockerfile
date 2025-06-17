# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:3.22.0

# Resolve DL4006 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Labels
LABEL org.opencontainers.image.authors="Thomas Deutsch <thomas@tuxpeople.org>"

COPY scripts/* /scripts/
COPY requirements.txt /requirements.txt

# hadolint ignore=DL3017,DL3018,DL3013
RUN chmod +x /scripts/* \
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
    && curl -s https://fluxcd.io/install.sh | bash \
    && curl -L https://carvel.dev/install.sh | K14SIO_INSTALL_BIN_DIR=/usr/local/bin bash \
    && apk add --no-cache --virtual .build-deps musl-dev python3-dev libffi-dev openssl-dev cargo make \
    && pip install --break-system-packages --no-cache-dir --upgrade pip \
    && pip install --break-system-packages --no-cache-dir --requirement /requirements.txt \
    && apk del .build-deps \
    && rm -f /requirements.txt \
    && crane completion bash > /etc/bash_completion.d/crane \
    && mkdir /workdir \
    && chmod 755 /workdir \
    && addgroup -g 1000 abc \
    && adduser -G abc -u 1000 abc -D

WORKDIR /workdir

# environment settings
ARG TZ="Europe/Zurich"
ENV PS1="\u@debugcontainer($(hostname)):\w\\$ " \
HOME="/workdir" \
TERM="xterm"

CMD ["/bin/sleep","inf"]
