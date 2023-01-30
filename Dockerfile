FROM node:12-alpine as node
FROM osgeo/gdal:alpine-small-latest

ENV NAME ahw-ogr-api
ENV USER microservice

RUN apk update && apk add bash

COPY --from=node /opt /opt
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/bin /usr/local/bin

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
