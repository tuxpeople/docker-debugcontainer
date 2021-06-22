# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:3.14.0

# Resolve DL4006 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Labels
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="debugcontainer-alpine"
LABEL org.label-schema.description="debugcontainer image alternative with Alpine"
LABEL org.label-schema.url="http://tuxpeople.org"

# Repository pinning https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Repository_pinning
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

COPY scripts/* /scripts/

# hadolint ignore=DL3017,DL3018
RUN chmod +x /scripts/* \
    && apk upgrade --no-cache \
    && apk add --no-cache \
      bash-completion \
      bind-libs \
      bind-tools \
      ca-certificates \
      curl \
      coreutils \
      dnsperf@testing \
      git \
      htop \
      iozone@testing \
      jq \
      lsof \
      mariadb-client \
      mc \
      minio-client@testing \
      mtr \
      netcat-openbsd \
      net-tools \
      nfs-utils \
      nmap \
      openssl \
      p7zip \
      screen \
      socat \
      sslscan@testing \
      tcpdump \
      tcptraceroute \
#      telnet \
      tmux \
      tree \
      vim \
      wget \
      which \
      fio \
      ioping \
      k9s \
      openssh-client \
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

CMD ["/scripts/idle.sh"]
