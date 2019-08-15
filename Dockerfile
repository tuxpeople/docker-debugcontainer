FROM alpine:latest
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
      libcrypto1.0 \
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
    && rm -rf /root/.cache/* \
    && wget https://www.dropbox.com/s/7pvxx1vfgqczyky/queryperf?dl=1 -o /bin/queryperf \
    && wget https://www.dropbox.com/s/8eoopsp7luxmlwa/resperf?dl=1 -o /bin/resperf \
    && wget https://www.dropbox.com/s/v9gd0xuytm7vset/dnsperf?dl=1 -o /bin/dnsperf \
    && chmod +x /bin/*perf


ENTRYPOINT [ "bash" ]
