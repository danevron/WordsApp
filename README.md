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

To start the Rails API (on localhost:3000) open a terminal window and run:

    bundle exec rails server

To start the background counting processing open a terminal window and run:

    bundle exec sidekiq

## Example usage

Counting is performed by issuing a POST request to `/count` endpoint.
Example request

```
curl -X POST \
http://localhost:3000/count \
-H 'Cache-Control: no-cache' \
-H 'Content-Type: application/json' \
-d '{
"text": "Text messaging, or texting, is the act of composing and sending electronic messages, typically consisting of alphabetic and numeric characters, between two or more users of mobile phones, tablets, desktops/laptops, or other devices."
}'
```

Getting the number of word occurrences is performed by issuing a GET request to `/count` endpoint.

```
curl -X GET 'http://localhost:3000/count?word=two'
```

## Testing

To run the tests suite run:

    bundle exec rspec
