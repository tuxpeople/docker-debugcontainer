#FROM centos:8
#FROM registry.access.redhat.com/ubi8/ubi
FROM registry.redhat.io/rhel8/support-tools

LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
#   && yum groupinstall "minimal" -y \
    && curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && curl -o /etc/yum.repos.d/mssql-cli.repo https://packages.microsoft.com/config/rhel/8/prod.repo \
    && curl -o epel.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum localinstall -y \
      epel.rpm \
    && rm -f epel.rpm \
    && yum update \
    && yum install -y \
      net-tools \
      tcpdump \
      wget \
      mssql-tools \
      bash-completion \
      lsof \
      nmap \
      telnet \
      tree \
      jq \
      bind-utils \
      tcptraceroute \ 
      tcpdump \
      socat \
      htop \
      mc \
      vim \
      screen \
      tmux \
      git \
      MariaDB-client \
      ca-certificates \
      mtr \
      p7zip \
      python38 \
#      iozone \
#      dnf \
#      dnf-plugins-core \
#    && dnf copr enable @dnsoarc/dnsperf -y \
#    && yum install dnsperf resperf -y \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && wget -O /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli \
    && export PS1="Debugcontainer: \w \\$ "
    
ENTRYPOINT [ "bash" ]
