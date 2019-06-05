FROM alpine:edge

MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

RUN apk add --update curl tcptraceroute nmap openssl elinks busybox-extras && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/bin/sh" ]
