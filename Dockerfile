FROM alpine:latest as builder
LABEL builder=true
MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

RUN apk add --update g++ make git bind bind-dev openssl-dev \
    libxml2-dev libcap-dev json-c-dev libcrypto1.0

RUN git clone https://github.com/akamai/dnsperf
RUN cd dnsperf && ./configure && make && strip dnsperf resperf
RUN git clone https://gitlab.isc.org/isc-projects/bind9.git
RUN cd bind9 && git checkout v9_12_1 && cd contrib/queryperf && ./configure && make && strip queryperf

FROM alpine:latest
ENV PS1="debugcontainer# "

COPY --from=builder /dnsperf/dnsperf /bin
COPY --from=builder /dnsperf/resperf /bin
COPY --from=builder /bind9/contrib/queryperf /bin

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
    && rm -rf /root/.cache/*


ENTRYPOINT [ "bash" ]
