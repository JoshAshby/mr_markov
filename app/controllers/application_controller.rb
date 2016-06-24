class ApplicationController < BaseController
  use HealthController
  use AuthenticationController
  use TelegramController
  use StacksController

  get '/' do
    haml :index
  end
end
