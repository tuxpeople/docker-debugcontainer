FROM infoblox/dnstools

MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

RUN apk add --update \
      # Basic shell stuff
      bash \
      bash-completion \
      readline \
      busybox-extras \
      grep \
      gawk \
      tree \
      sed \
      # Interacting with the networks
      curl \
      wget \
      openssl \
      bind-tools \ 
      tcptraceroute \ 
      jq \
      drill \
      nmap \
      netcat-openbsd \
      socat \
      # Monitoring / Shell tools
      htop \
      mc \
      # Development tools
      g++ \
      gcc \
      python3 \
      unixodbc-dev \
      vim \
      elinks \
      tmux \
      git \
      tig \
      mysql-client \
      ca-certificates \
      python3-dev \
      alpine-sdk \
    && rm -rf /var/cache/apk/* \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade Cython --install-option="--no-cython-compile" \
    && pip3 install --upgrade py3-setuptools \
    && pip3 install mssql-cli \
#    && pip3 install pymssql \
#    && pip3 install pyobdc \
    && rm -rf /var/cache/* \
    && rm -rf /root/.cache/*


ENTRYPOINT [ "bash" ]
