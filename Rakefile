require 'rake/clean'
require 'rake/testtask'

require 'yard'

CLEAN << 'coverage/'
CLEAN << 'doc/'

CLOBBER << 'cache/'

task :environment do
  require_relative './mr_markov'
end

Rake.add_rakelib 'lib/tasks'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*test.rb"
  t.warning = false
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

  options = [  '--no-private', '--charset', 'utf-8', '--markup', 'markdown', '--readme', 'README.md' ]
  options.unshift '--output-dir', File.join(ENV['BUILD_ARTIFACTS'] || './', 'docs')

  t.options = options

  t.stats_options = ['--list-undoc']
end

