FROM ruby:3.1.0-alpine
WORKDIR /code
RUN bundle config set --local without 'development test'
RUN apk update
RUN apk add --virtual build-dependencies build-base ruby-dev libpq postgresql-dev tzdata git
COPY Gemfile /code
RUN bundle install 
COPY . /code
CMD rails s -b 0.0.0.0 -p ${RAILS_PORT:-80} -e production