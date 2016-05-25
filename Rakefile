require 'rake/clean'
require 'rake/testtask'

require 'yard'

CLEAN << 'coverage/'
CLEAN << 'doc/'

CLOBBER << 'cache/'

task :environment do
  require_relative './mr_markov'
end

namespace :mr_markov do
  desc "Installs the telegram webhook"
  task install: :environment do
    bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger

    bot.api.setWebhook url: "https://mrmarkov.themoon.isin.space/hook_#{ ENV['TELEGRAM_TOKEN'] }"
    puts "Webhook installed!"
  end

  desc "Uninstalls the telegram webhook"
  task uninstall: :environment do
    bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger

    bot.api.setWebhook url: ""
    puts "Webhook uninstalled!"
  end
end

namespace :redis do
  desc "Flushes the current redis instance, to clean away all keys"
  task flush: :environment do
    puts "Flushing redis"

    Redis.current.flushall
  end
end

namespace :db do
  desc "Runs the Sequel migrations"
  task migrate: :environment do
    puts "Running migrations"

    Sequel.extension :migration
    Sequel::Migrator.run DB, AshFrame.root.join('db', 'migrations')
  end

  desc "Seeds the database with the nescessary starting data"
  task seed: :environment do
    puts "Loading seed data"

    require_relative './db/seeds'
  end

  desc "Reset, migrate and reseed seed"
  task reset: :environment do
    puts "Droping existing tables"
    DB.run 'DROP SCHEMA IF EXISTS public CASCADE'
    DB.run 'CREATE SCHEMA IF NOT EXISTS public;'
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
  end
end

namespace :rabbitmq do
  desc 'Setup rabbitmq routing'
  task setup: :environment do
    ch = SpaceScrape.bunny.create_channel

    workers_exchange = ch.direct 'mr_markov.workers'
    Workers.constants.each do |c|
      const = Workers.const_get c

      next unless const.ancestors.include? Sneakers::Worker
      next unless const.queue_name
      ch.queue( const.queue_name, durable: false, auto_delete: false, arguments: { "x-max-priority" => 100 } ).bind workers_exchange, routing_key: const.routing_key
    end

    pubsub_exchange = ch.topic 'mr_markov.pubsub'
    Subscribers.constants.each do |c|
      const = Subscribers.const_get c

      next unless const.ancestors.include? Sneakers::Worker
      next unless const.queue_name
      ch.queue( const.queue_name, durable: false, auto_delete: true ).bind pubsub_exchange, routing_key: "#{ const.namespace }.#"
    end
  end
end

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*test.rb"
end

ENV['COVERAGE'] = 'true'
task default: :test

namespace :test do
  desc 'Generates a coverage report'
  task :nocoverage do
    ENV['COVERAGE'] = 'false'
    Rake::Task['test'].execute
  end
end


YARD::Rake::YardocTask.new do |t|
  t.files = ['app/**/*.rb', 'lib/**/*.rb', 'test/helpers/**/*.rb', 'test/mocks/**/*.rb', 'mr_markov.rb']

  options = [ '-', 'README.md' ]
  options.unshift '--output-dir', File.join(ENV['BUILD_ARTIFACTS'] || './', 'docs')

  t.options = options

  # t.stats_options = ['--list-undoc']
end
