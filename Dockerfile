FROM alpine

ENV SPIGOT_VERSION=latest

STOPSIGNAL SIGINT

RUN apk --update add --no-cache tini git openjdk8-jre curl bash screen pstree
RUN apk --update add --no-cache tini git openjdk8-jre curl bash screen pstree
RUN mkdir /minecraft

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD [ "server" ]
