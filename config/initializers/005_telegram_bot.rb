require 'telegram/bot'
require 'excon'

Telegram::Bot.configure do |config|
  config.adapter = :excon
end

class MrMarkov
  def self.telegram_api
    @bot ||= Telegram::Bot::Api.new ENV['TELEGRAM_TOKEN']
  end
end
