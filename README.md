# Word counting service

The service exposes an API for:

1.  Counting and aggregating word occurrences.
2.  GETing the number of occurrences for a given word.

# Assumptions

- API input Context-Type is application/json.
- Input text contains plain English characters (together with punctuation marks).
- Words are case insensitive, have no meaning and may include numbers.
- Numbers are considered as words. Punctuation marks can be ignored.
- POSTed text fits within HTTP maximum size restriction.
- Counting can be performed offline. This means that the count will be be eventually consistent.
- API endpoint for counting should except counting requests regardless of ongoing counting being performed.

## Requirements

- Mac OS X
- Ruby version 2.4.*
- Redis installed and is listening on localhost, port 6379

## Installation

Install Redis via Homebrew:

    brew install redis

To start Redis, open a new terminal window and run:

    redis-server /usr/local/etc/redis.conf

Install Ruby with RVM

    rvm install 2.4 --default

Install Bundler

    gem install bundler

Install the project dependencies

    bundle install

## Start the service

Make sure Redis is running.

To start the Rails API open a terminal window and run:

    bundle exec rails server

To start the background counting processing open a terminal window and run:

    bundle exec sidekiq

## Testing

To run the tests suite run:

    bundle exec rspec
