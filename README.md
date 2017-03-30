# Swarm

## Dependencies

* PostgreSQL 9
* Ruby 2.3.1
* Rails 5
* Redis
* Sidekiq

## Quick Start

```bash
# clone repo
git clone git@github.com:slavakisel/swarm.git
cd swarn

# run setup script
bin/setup

# run specs
bin/rspec

# run server on 5000 port
bin/server
```

## Staging

* http://swarm-staging.herokuapp.com

## cURL

`bin/index url` - will post url to heroku server via cURL, E.g.: `bin/index http://example.org`
