FROM ruby:3.0.2-alpine
WORKDIR /code
RUN bundle config set --local without 'development test'
RUN apk update
RUN apk add --virtual build-dependencies build-base ruby-dev libpq postgresql-dev tzdata
COPY Gemfile /code
RUN bundle install 
COPY . /code
CMD rails s -b 0.0.0.0 -p ${RAILS_PORT:-80} -e production