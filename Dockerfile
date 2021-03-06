FROM node:10-alpine
MAINTAINER Sven Fischer <sven@leiderfischer.de>

WORKDIR /src

RUN apk add --no-cache --virtual .build-deps \
  git python make g++ \
  && apk add --no-cache openssh-client \
  && git clone https://github.com/krishnasrinivas/wetty --branch v1.1.4 /src \
  && npm install \
  && apk del .build-deps \
  && adduser -h /src -D term \
  && npm run-script build

ADD run.sh /src

RUN useradd -d /home/term -m -s /bin/bash term
RUN echo 'term:term' | chpasswd
RUN sudo adduser term sudo


# Default ENV params used by wetty
ENV REMOTE_SSH_SERVER=127.0.0.1 \
    REMOTE_SSH_PORT=22

RUN chmod +x /src/run.sh
WORKDIR /src
ENTRYPOINT ["/src/run.sh"]
CMD ["/src/run.sh"]
