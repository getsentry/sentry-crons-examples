FROM ruby:3.2-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile ./
RUN bundle install --jobs 4 --retry 3

# Copy application files
COPY . .

# Run clockwork
CMD ["bundle", "exec", "clockwork", "clock.rb"]