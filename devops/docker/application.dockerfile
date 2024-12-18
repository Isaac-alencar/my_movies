# syntax = docker/dockerfile:1

# Setting up the ruby version
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim AS base

# Setting the work directory
ARG APP_HOME=/usr/src/app
WORKDIR $APP_HOME

# Install base packages
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \ 
    git \ 
    libpq-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
    
# Copying dependencies file
COPY Gemfile Gemfile.lock $APP_HOME/
COPY package.json package-lock.json $APP_HOME/

# Installing dependencies
RUN bundle install --jobs 4 --retry 3
RUN npm install

COPY . .

# Final stage for app image
FROM build

# Copying the rest of the code
COPY --from=build /usr/src/app /usr/src/app

# Entrypoint prepares the database.
ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint"]

CMD ["./bin/dev"]