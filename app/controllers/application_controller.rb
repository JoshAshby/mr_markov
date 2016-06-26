class ApplicationController < BaseController
  use HealthController
  use AuthenticationController
  use TelegramController
  use StacksController
  use ChronotriggersController

  get '/' do
    haml :index
  end
end
