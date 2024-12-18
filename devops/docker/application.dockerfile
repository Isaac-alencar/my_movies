# syntax = docker/dockerfile:1

# Setting up the ruby version
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION

# Install nodejs
ARG DEBIAN_FRONTEND=noninteractive

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - 
RUN apt-get install -y nodejs

# Check npm version
RUN npm --version

# Setting the work directory
ARG APP_HOME=/usr/src/app
WORKDIR $APP_HOME

# Copying dependencies file
COPY Gemfile Gemfile.lock $APP_HOME/
COPY package.json package-lock.json $APP_HOME/

# Installing dependencies
RUN bundle install

RUN npm install

# Copying the rest of the code
COPY . $APP_HOME/
