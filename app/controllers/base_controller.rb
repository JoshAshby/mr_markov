require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/flash'

require 'erb'
require 'tilt/erb'

require 'haml'
require 'tilt/haml'

require 'rack/session/redis'

class BaseController < Sinatra::Base
  set :views, -> { AshFrame.root.join 'app', 'views' }
  set :public_folder, -> { AshFrame.root.join 'public' }

  # Setup logging for access and error logs, just for niceness.
  access_log        = AshFrame.root.join('logs', 'access.log')
  access_logger     = Logger.new(access_log)
  error_logger      = AshFrame.root.join('logs', 'error.log').open("a+")
  error_logger.sync = true

  configure do
    use ::Rack::CommonLogger, access_logger
  end

  before do
    env["rack.errors"] = error_logger
  end

  # enable :sessions
  # use Rack::Session::Cookie
  use Rack::Session::Redis

  helpers Sinatra::ContentFor, AuthenticationHelper, PartialHelper
  register Sinatra::Flash

  def authenticate!
    unless logged_in?
      session[:return_path] = request.path
      flash[:error] = "You need to login to access that"
      halt redirect(to('/login'))
    end
  end

  def self.auth_get *args, &block
    get(*args) do
      authenticate!
      block.call
    end
  end
end
