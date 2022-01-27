FROM ruby:alpine
WORKDIR /code
COPY . /code
RUN apk update && apk add --virtual build-dependencies build-base ruby-dev libpq postgresql-dev tzdata
RUN bundle config set --local without 'development test'
RUN bundle install 
CMD rails s -b 0.0.0.0 -p 80 -e production

