FROM centos:7
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"

RUN yum update -y \
    && yum groupinstall "minimal" -y \
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
    && yum clean all
    
ENTRYPOINT [ "bash" ]
