FROM centos:8

LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
    && curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo \
    && curl -o /etc/yum.repos.d/group_dnsoarc-dnsperf-epel-8.repo https://copr.fedorainfracloud.org/coprs/g/dnsoarc/dnsperf/repo/epel-8/group_dnsoarc-dnsperf-epel-8.repo \
    && yum install -y \
      epel-release \
    && yum update -y \
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
      #iozone \
      unixODBC-devel \
      dnsperf \		
      resperf \	
    && yum clean all \
    && rm -rf /var/cache/yum \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
    && curl -o /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli \
    && export PS1="Debugcontainer: \w \\$ "
    
ENTRYPOINT [ "bash" ]
