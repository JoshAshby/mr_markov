class ApplicationController < BaseController
  use HealthController

  attr_reader :bot

  def initialize
    super

    @bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger
  end

  post "/hook_#{ ENV['TELEGRAM_TOKEN'] }" do
    puts params
    bot.api.send_message chat_id: 204348342, text: "Hello"
  end
end
