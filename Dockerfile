FROM infoblox/dnstools

MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

RUN apk add --update curl tcptraceroute nmap openssl elinks busybox-extras mysql-client && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/bin/sh" ]
