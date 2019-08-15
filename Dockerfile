FROM centos:7
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
#    && yum groupinstall "minimal" -y \
    && curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && curl -o /etc/yum.repos.d/mssql-cli.repo https://packages.microsoft.com/config/rhel/7/prod.repo \
    && yum install -y \
      epel-release \
    && yum update \
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
    && yum clean all
    
ENTRYPOINT [ "bash" ]
