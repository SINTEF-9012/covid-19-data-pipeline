FROM alpine:3.6

RUN apk update -vU --allow-untrusted
RUN apk add bash
RUN apk add openjdk8-jre

COPY ./bash_scripts /code
COPY ./common_scripts /code

ENTRYPOINT ["/code/main.sh"]
