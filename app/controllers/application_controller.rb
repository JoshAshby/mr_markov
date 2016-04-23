class ApplicationController < BaseController
  use HealthController

  attr_reader :bot

  def initialize
    super

    @bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger
  end

  post "/hook_#{ ENV['TELEGRAM_TOKEN'] }" do
    puts params
  end
end
