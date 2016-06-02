source 'https://rubygems.org'
ruby '2.3.1'

gem 'rake'
gem 'thor'
gem 'require_all'

# gem 'ash_frame', path: '../ash_frame' # Local
gem 'ash_frame', git: 'http://code.isin.space/JoshAshby/AshFrame.git' # Git

# The sadness, but lots of useful helpers
gem 'activesupport', '~> 4', require: 'active_support/all'

# Request making
gem 'faraday'
gem 'faraday_middleware'
# gem 'typhoeus'
gem 'excon'
# gem 'robotstxt-parser', require: 'robotstxt'

# Parsing/HTML handling
gem 'nokogiri'
# gem 'loofah'
# gem 'ruby-readability'
gem 'jsonpath'

# Text analysis and ML
# gem 'words_counted'
# gem 'classifier-reborn', path: '../contrib/classifier-reborn' # Local
# gem 'classifier-reborn', git: 'https://github.com/JoshAshby/classifier-reborn.git' # Git
# gem 'stopwords-filter'

# Datastore gems
# gem 'connection_pool'

## Postgres, ORM
gem 'pg'
gem 'sequel'
gem 'sequel_pg', require: 'sequel'
gem 'globalid'

gem 'bcrypt'
gem 'sequel_secure_password'

## Redis Utils
gem 'redis'
gem 'hiredis'
# gem 'redis-namespace'
# gem 'redlock'

gem 'redis-activesupport'
gem 'redis-rack'

## Elasticsearch
# gem 'elasticsearch'
# gem 'elasticsearch-model'
# gem 'chewy'

## Neo4j
# gem 'neo4j'

# Communication
## RabbitMQ
# gem 'bunny'

# Async Workers
gem 'sidekiq'  # Redis Backed
# gem 'sneakers' # RabbitMQ Backed

# Frontend
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-flash'
gem 'haml'
gem 'liquid'
# gem 'opal'

gem 'thin'

# Chat systems
gem 'telegram-bot-ruby'

gem 'foreman'

group :doc do
  gem 'yard'
end

group :development, :test do
  gem 'byebug'
  gem 'awesome_print'

  gem 'guard'
  gem 'guard-minitest'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-stub_any_instance'
  gem 'minitest-focus'
  # gem 'rack-test'
  gem 'simplecov', require: false
end
