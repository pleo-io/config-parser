FROM alpine:3.18.4

RUN apk add bash

COPY ./validate.sh validate.sh
COPY ./run.sh run.sh

ENTRYPOINT [ "bash", "run.sh" ]
