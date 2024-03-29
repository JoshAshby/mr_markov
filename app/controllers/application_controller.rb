class ApplicationController < BaseController
  enable :sessions

  use HealthController

  use AuthenticationController

  use TelegramController

  use StacksController
  use FramesController
  use ChronotriggersController

  get '/' do
    haml :index
  end
end
