# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

# From Alpine edge
FROM alpine:latest

# MSSQL_VERSION can be changed, by passing `--build-arg MSSQL_VERSION=<new version>` during docker build
ARG MSSQL_VERSION=17.5.2.1-1
ENV MSSQL_VERSION=${MSSQL_VERSION}

ENV DNSPERF dnsperf-2.3.4

# Labels
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="debugcontainer-alpine"
LABEL org.label-schema.description="debugcontainer image alternative with Alpine"
LABEL org.label-schema.url="http://tuxpeople.org"

# environment settings
ARG TZ="Europe/Oslo"
ENV PS1="$(whoami)@debugcontainer($(hostname)):$(pwd)\\$ " \
HOME="/root" \
TERM="xterm"

# Repository pinning https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Repository_pinning
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

WORKDIR /tmp
# Installing MSSQL-Tools
RUN apk add --no-cache curl gnupg --virtual .build-dependencies -- && \
    # Adding custom MS repository for mssql-tools and msodbcsql
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Verifying signature
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.sig && \
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.sig && \
    # Importing gpg key
    curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import - && \
    gpg --verify msodbcsql17_${MSSQL_VERSION}_amd64.sig msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
    gpg --verify mssql-tools_${MSSQL_VERSION}_amd64.sig mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Installing packages
    echo y | apk add --allow-untrusted msodbcsql17_${MSSQL_VERSION}_amd64.apk mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Deleting packages
    apk del .build-dependencies && rm -f msodbcsql*.sig mssql-tools*.apk

# Installing DNSPERF and RESPERF
RUN apk add --update --no-cache --virtual deps wget g++ make bind-dev openssl-dev libxml2-dev libcap-dev json-c-dev krb5-dev protobuf-c-dev fstrm-dev \
  && apk add --update --no-cache bind libcrypto1.1 \
  && wget https://www.dns-oarc.net/files/dnsperf/$DNSPERF.tar.gz \
  && tar zxvf $DNSPERF.tar.gz \
  && cd $DNSPERF \
  && sh configure \
  && make \
  && strip ./src/dnsperf ./src/resperf \
  && make install \
  && apk del deps \
  && rm -rf /$DNSPERF*

RUN apk add --update --no-cache \
      bash-completion \
      bind-libs \
      bind-tools \
      ca-certificates \
      git \
      htop \
      iozone@testing \
      jq \
      lsof \
      mariadb-client \
      mc \
      mtr \
      netcat-openbsd \
      net-tools \
      nfs-utils \
      nmap \
      p7zip \
      screen \
      socat \
      tcpdump \
      tcptraceroute \
#      telnet \
      tmux \
      tree \
      vim \
      wget \
      which \
    && curl -o /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli

WORKDIR /
# Adding SQL Server tools to $PATH
ENV PATH=$PATH:/opt/mssql-tools/bin:/bin/
CMD ["/bin/bash"]
