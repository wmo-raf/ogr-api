FROM node:12-alpine

ENV NAME eahw-ogr-api
ENV USER microservice

# dependecies
RUN apk update && apk upgrade && \
    apk add --no-cache --update bash alpine-sdk

# install gdal
RUN apk add \
  --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  gdal-dev \
  gdal-tools

RUN addgroup $USER && adduser -s /bin/bash -D -G $USER $USER

RUN yarn global add grunt-cli bunyan

RUN mkdir -p /opt/$NAME
ADD package.json /opt/$NAME/package.json
COPY yarn.lock /opt/$NAME/yarn.lock
RUN cd /opt/$NAME && yarn

COPY entrypoint.sh /opt/$NAME/entrypoint.sh
COPY config /opt/$NAME/config

WORKDIR /opt/$NAME

COPY --chown=$USER:$USER ./app /opt/$NAME/app

USER $USER

ENTRYPOINT ["./entrypoint.sh"]
