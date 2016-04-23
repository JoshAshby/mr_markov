class ApplicationController < BaseController
  use HealthController

  post "/hook_#{ ENV['TELEGRAM_TOKEN'] }" do
    request.body.rewind
    request_payload = JSON.parse request.body.read

    update = Telegram::Bot::Types::Update.new request_payload
    RoutingBlock[ message: update.message ]

    status 200
  end
end
