class ApplicationController < BaseController
  use HealthController

  attr_reader :bot

  def initialize
    super

    @bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger
    @messages = []
  end

  get '/fetch' do
    res = JSON.dump @messages

    @messages = []

    res
  end

  post "/hook_#{ ENV['TELEGRAM_TOKEN'] }" do
    puts params.to_h

    request.body.rewind
    puts request.body.read

    request.body.rewind
    request_payload = JSON.parse request.body.read

    @messages << request_payload

    bot.api.send_message chat_id: 204348342, text: "Hello"

    status 200
  end
end
