FROM centos:8

LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
    && curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo \
    #&& curl -o /etc/yum.repos.d/group_dnsoarc-dnsperf-epel-8.repo https://copr.fedorainfracloud.org/coprs/g/dnsoarc/dnsperf/repo/epel-8/group_dnsoarc-dnsperf-epel-8.repo \
    && yum install -y \
      epel-release \
    && yum update -y \
    && yum install -y \
      bash-completion \
      bind-libs \
      bind-utils \
      ca-certificates \
      dnsperf \
      git \
      htop \
      #iozone \
      jq \
      lsof \
      MariaDB-client \
      mc \
      #mssql-tools \
      mtr \
      nc \
      net-tools \
      nfs-utils \
      nmap \
      p7zip \
      python38 \
      resperf \
      screen \
      socat \
      tcpdump \
      tcptraceroute \
      telnet \
      tmux \
      tree \
      #unixODBC-devel \
      vim \
      vim-enhanced \
      wget \
      which \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
    && curl -o /bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    && chmod +x /bin/speedtest-cli \
    && alternatives --set python /usr/bin/python3 \
    && export PS1="Debugcontainer: \w \\$ "
    
ENTRYPOINT [ "bash" ]
