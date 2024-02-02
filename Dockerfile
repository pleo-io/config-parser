FROM alpine:3.18.4

RUN apk add bash

RUN apk add wget

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.7/jq-linux64 && \
  mv jq-linux64 /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq

COPY ./load-env.sh load-env.sh

ENTRYPOINT [ "bash", "load-env.sh" ]
