FROM ruby:3.1.0

WORKDIR /code

RUN apt-get update && apt-get install -y build-essential libpq-dev

COPY Gemfile /code

RUN bundle install

COPY . /code

ENTRYPOINT entrypoint.sh
