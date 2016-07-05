require 'bundler/setup'

require 'ash_frame'
AshFrame.configure do |config|
  config.root = File.dirname __FILE__
  config.app_name = 'mrmarkov'
end

Bundler.require :default, AshFrame.environment

class MrMarkov; end

require 'require_all'
require_rel %w| config/initializers lib app/workers app/blocks app/processors app/models |
