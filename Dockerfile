FROM ruby:2.4.1-alpine3.6
MAINTAINER Brian Ustas <brianustas@gmail.com>

ARG APP_PATH="/opt/emoji_soup"

RUN apk add --update \
  nodejs \
  nodejs-npm \
  build-base \
  && rm -rf /var/cache/apk/*

# CoffeeScript
RUN npm install -g coffeescript@1.6.3

# Sass
RUN gem install sass -v 3.5.1 --no-user-install

WORKDIR $APP_PATH
COPY . $APP_PATH
VOLUME $APP_PATH

CMD ["rake", "build_public"]
