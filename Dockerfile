FROM ruby:3.0.2-alpine
RUN apk update
RUN apk add --virtual build-dependencies build-base ruby-dev libpq postgresql-dev tzdata
WORKDIR /code
COPY Gemfile /code
RUN bundle config set --local without 'development test'
RUN bundle install 
COPY . /code
CMD rails s -b 0.0.0.0 -p 80 -e production

