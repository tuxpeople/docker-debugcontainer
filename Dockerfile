FROM alpine:edge

MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

RUN apk add --update curl tcptraceroute && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/bin/sh" ]
