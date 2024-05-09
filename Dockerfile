FROM alpine:3.18.4

RUN apk add bash

COPY ./parse-config.sh parse-config.sh

ENTRYPOINT [ "bash", "parse-config.sh" ]
