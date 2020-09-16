# Debugcontainer - custom image
# Thanks to https://github.com/dbamaster/mssql-tools-alpine
# From Alpine 3.11 (~5 MBs)
FROM alpine:3.11

# MSSQL_VERSION can be changed, by passing `--build-arg MSSQL_VERSION=<new version>` during docker build
ARG MSSQL_VERSION=17.5.2.1-1
ENV MSSQL_VERSION=${MSSQL_VERSION}

# Labels
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="debugcontainer-alpine"
LABEL org.label-schema.description="debugcontainer image alternative with Alpine"
LABEL org.label-schema.url="http://tuxpeople.org"

# environment settings
ARG TZ="Europe/Oslo"
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
HOME="/root" \
TERM="xterm"

WORKDIR /tmp
# Installing system utilities
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

RUN apk add --no-cache \
      bash-completion \
      bind-libs \
      bind-utils \
      ca-certificates \
      dnsperf \
      git \
      htop \
      #iozone \
      jq \
      lsof \
      MariaDB-client \
      mc \
      mtr \
      nc \
      net-tools \
      nfs-utils \
      nmap \
      p7zip \
      python38 \
      resperf \
      screen \
      socat \
      tcpdump \
      tcptraceroute \
      telnet \
      tmux \
      tree \
      vim \
      vim-enhanced \
      wget \
      which \
    && curl -o /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli

WORKDIR /
# Adding SQL Server tools to $PATH
ENV PATH=$PATH:/opt/mssql-tools/bin:/bin/
CMD ["/bin/sh"]
