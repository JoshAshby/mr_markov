class ApplicationController < BaseController
  use HealthController
  use AuthenticationController
  use TelegramController

  get '/' do
    haml :index
  end
end
