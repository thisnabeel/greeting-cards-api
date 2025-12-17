# syntax=docker/dockerfile:1
FROM ruby:2.5.7-bullseye

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby gems
COPY Gemfile* ./
RUN bundle install

# Copy application code
COPY . .

EXPOSE 3000

# Clear stale server pids, run migrations, then start Rails
CMD ["bash", "-lc", "bundle exec rake tmp:pids:clear db:migrate && bundle exec rails server -b 0.0.0.0"]