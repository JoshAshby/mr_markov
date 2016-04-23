class ApplicationController < BaseController
  use HealthController

  attr_reader :bot

  def initialize
    super

    @bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger
  end

  post "/hook_#{ ENV['TELEGRAM_TOKEN'] }" do
    request.body.rewind
    request_payload = JSON.parse request.body.read

    update = Telegram::Bot::Types::Update.new request_payload
    RoutingBlock[ bot: @bot, message: update.message ]

    status 200
  end
end
