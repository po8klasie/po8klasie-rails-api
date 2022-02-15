FROM ruby:3.1.0
WORKDIR /code
RUN bundle config set --local without 'development test'
RUN apt-get update && apt-get install -y build-essential libpq-dev
COPY Gemfile /code
RUN echo "invalidate cache"
RUN bundle install
COPY . /code
CMD bin/rails s -b 0.0.0.0 -p 80 -e production
