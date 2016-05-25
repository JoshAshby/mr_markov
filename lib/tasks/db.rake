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

    require_relative AshFrame.root.join('db', 'seeds')
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
