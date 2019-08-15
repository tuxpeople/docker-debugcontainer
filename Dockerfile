FROM ubuntu:latest
RUN useradd -u 10001 scratchuser

FROM infoblox/dnstools
COPY --from=0 /etc/passwd /etc/passwd
ENV PS1="debugcontainer# "

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
      curl \
      tcptraceroute \ 
      jq \
      drill \
      nmap \
      netcat-openbsd \
      socat \
      tcpdump \
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
      freetds-dev \
    && rm -rf /var/cache/apk/* \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade Cython --install-option="--no-cython-compile" \
    && pip3 install --upgrade setuptools \
    && pip3 install mssql-cli \
    && rm -rf /var/cache/* \
    && rm -rf /root/.cache/*

USER scratchuser

ENTRYPOINT [ "bash" ]
