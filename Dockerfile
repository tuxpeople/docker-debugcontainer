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
      unixodbc-dev \
      vim \
      elinks \
      tmux \
      git \
      tig \
      mysql-client \
      ca-certificates \
    && \
    rm -rf /var/cache/apk/* \
    && \
    pip install pymssql \
    && \
    pip install pyobdc

ENTRYPOINT [ "bash" ]
