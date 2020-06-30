FROM centos:7
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
#   && yum groupinstall "minimal" -y \
    && curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && curl -o /etc/yum.repos.d/mssql-cli.repo https://packages.microsoft.com/config/rhel/7/prod.repo \
    && yum install -y \
      epel-release \
    && yum update -y \
    && yum install -y \
      net-tools \
      tcpdump \
      wget \
      mssql-cli \
      bash-completion \
      bash-completion-extras \
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
      elinks \ 
      screen \
      tmux \
      git \
      MariaDB-client \
      ca-certificates \
      mtr \
      p7zip \
      python \
      iozone \
 #     dnf \		
 #     dnf-plugins-core \		
 #   && dnf copr enable @dnsoarc/dnsperf -y \		
 #   && yum -y remove dnf-plugins-core dnf \		
 #   && yum install dnsperf resperf -y \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && curl -o /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli \
    && export PS1="Debugcontainer: \w \\$ "
    
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
