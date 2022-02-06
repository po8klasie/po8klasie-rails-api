FROM ruby:3.0.2-alpine

ENV APP_DIR /opt/app

RUN mkdir -p $APP_DIR

WORKDIR $APP_DIR

RUN bundle config set --local without 'development test'

RUN apk update

RUN apk add --virtual build-dependencies build-base ruby-dev libpq postgresql-dev tzdata

COPY Gemfile $APP_DIR

RUN bundle install

COPY . $APP_DIR

CMD rails s -b 0.0.0.0 -p 3000 -e production
