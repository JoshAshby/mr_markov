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
