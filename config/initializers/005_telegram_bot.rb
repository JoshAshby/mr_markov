require 'telegram/bot'
require 'excon'

Telegram::Bot.configure do |config|
  config.adapter = :excon
end
