# Debugcontainer - custom image
# 
# Thanks to
#   - https://github.com/dbamaster/mssql-tools-alpine
#   - https://github.com/ssro/dnsperf

FROM alpine:3.13.1

# MSSQL_VERSION can be changed, by passing `--build-arg MSSQL_VERSION=<new version>` during docker build
# $(curl -s https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15 | grep "verify" | grep msodbcsql17 | awk '{ print $3}' | cut -d'_' -f2)
#ARG MSSQL_VERSION=17.6.1.1-1
#ENV MSSQL_VERSION=${MSSQL_VERSION}

# Resolve DL4006 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Labels
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="debugcontainer-alpine"
LABEL org.label-schema.description="debugcontainer image alternative with Alpine"
LABEL org.label-schema.url="http://tuxpeople.org"

# environment settings
ARG TZ="Europe/Zurich"
ENV PS1="\u@debugcontainer($(hostname)):\w\\$ " \
HOME="/" \
TERM="xterm"

# Repository pinning https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Repository_pinning
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

#WORKDIR /tmp
# Installing MSSQL-Tools
# hadolint ignore=DL3018,DL3019
#RUN apk add --no-cache wget gnupg --virtual .build-dependencies -- && \
    # Adding custom MS repository for mssql-tools and msodbcsql
#    wget https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
#    wget https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Verifying signature
#    wget https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.sig && \
#    wget https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.sig && \
    # Importing gpg key
#    wget -O - https://packages.microsoft.com/keys/microsoft.asc  | gpg --import - && \
#    gpg --verify msodbcsql17_${MSSQL_VERSION}_amd64.sig msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
#    gpg --verify mssql-tools_${MSSQL_VERSION}_amd64.sig mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Installing packages
#    echo y | apk add --allow-untrusted msodbcsql17_${MSSQL_VERSION}_amd64.apk mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Deleting packages
#    apk del .build-dependencies && rm -f msodbcsql*.sig mssql-tools*.apk

COPY scripts/* /scripts/

# hadolint ignore=DL3017,DL3018
RUN chmod +x /scripts/* \
    && apk upgrade --no-cache \
    && apk add --no-cache \
      bash-completion \
      bind-libs \
      bind-tools \
      ca-certificates \
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
      fio \
      ioping \
    && wget -O /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli

WORKDIR /
# Adding SQL Server tools to $PATH
# ENV PATH=$PATH:/opt/mssql-tools/bin:/bin/
CMD ["/scripts/idle.sh"]
