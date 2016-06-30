$:.unshift File.dirname(__FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test/'
    add_filter '.gems/'
    add_filter '.bundle/'
    add_filter 'config/'
    add_filter 'bin/'

    # minimum_coverage 80
    # refuse_coverage_drop

    coverage_dir File.join(ENV['BUILD_ARTIFACTS'], "coverage") if ENV['BUILD_ARTIFACTS']

    command_name 'Minitest'

    add_group 'Processors' do |file|
      file.filename =~ /\/processors/
    end

    add_group 'Blocks' do |file|
      file.filename =~/\/blocks/
    end

    add_group 'Models' do |file|
      file.filename =~ /\/models/
    end

    add_group 'Controllers' do |file|
      file.filename =~ /\/controllers/
    end

    add_group 'Workers' do |file|
      file.filename =~ /\/workers/
    end

    add_group 'Helpers' do |file|
      file.filename =~/\/helpers/
    end

    add_group 'Presenters' do |file|
      file.filename =~/\/presenters/
    end
  end
end

ENV['RACK_ENV'] = 'test'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'minitest/autorun'
require 'minitest/stub_any_instance'

require 'webmock/minitest'

WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)

require_relative '../mr_markov.rb'
require_rel 'mocks/', 'helpers/'
