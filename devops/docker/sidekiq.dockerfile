FROM ruby:3.3.0

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without development test

# Copy the application code
COPY . .

# Command to run Sidekiq
CMD ["bundle", "exec", "sidekiq", "-C", "config/schedule.yml"]
