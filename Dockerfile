FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install bundler
RUN mkdir /myapp
WORKDIR /myapp


CMD ["tail -f /dev/null"]
