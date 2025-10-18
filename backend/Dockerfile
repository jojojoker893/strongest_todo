FROM ruby:3.4
RUN apt-get update -qq && apt-get install -y vim

RUN mkdir /api
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

RUN gem update --system
RUN bundle update --bundler

RUN gem update --system && bundle install
COPY . /api

COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]