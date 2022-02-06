FROM ruby:3.1.0-slim-buster
WORKDIR /code
RUN bundle config set --local without 'development test'
RUN apt-get update
RUN apt-get install -y postgresql postgresql postgresql-contrib libpq-dev git
COPY Gemfile /code
RUN apt-get install -y pkg-config
RUN apt-get install -y build-essential autoconf automake libtool-bin libssl-dev libusb-1.0-0-dev
RUN bundle install 
COPY . /code
CMD rails s -b 0.0.0.0 -p ${RAILS_PORT:-80} -e production
