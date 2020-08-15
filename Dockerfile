FROM alpine

ENV SPIGOT_VERSION=latest

RUN apk --update add git openjdk8-jre curl
RUN mkdir /minecraft

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "server" ]
