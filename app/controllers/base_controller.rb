require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/flash'

require 'erb'
require 'tilt/erb'

require 'haml'
require 'tilt/haml'

class BaseController < Sinatra::Base
  set :views, -> { AshFrame.root.join 'app', 'views' }
  set :public_folder, -> { AshFrame.root.join 'public' }

  # Setup logging for access and error logs, just for niceness.
  access_log        = AshFrame.root.join('logs', 'access.log')
  access_logger     = Logger.new(access_log)
  error_logger      = AshFrame.root.join('logs', 'error.log').open("a+")
  error_logger.sync = true

  use Rack::CommonLogger, access_logger
  use Rack::MethodOverride # Allows the use of ujs and data-methods on links

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = AshFrame.root.to_s
  end

  before do
    env["rack.errors"] = error_logger
  end

  set :session_secret, ENV['SESSION_SECRET']

  helpers Sinatra::ContentFor, AuthenticationHelper, PartialHelper
  register Sinatra::Flash

  def authenticate!
    unless logged_in?
      session[:return_path] = request.path
      flash.now[:danger] = "You need to login to access that"

      halt haml(:login)
    end
  end

  def self.auth_get *args, &block
    get(*args) do
      authenticate!
      instance_eval(&block)
    end
  end

  def self.auth_post *args, &block
    post(*args) do
      authenticate!
      instance_eval(&block)
    end
  end

  def self.auth_put *args, &block
    put(*args) do
      authenticate!
      instance_eval(&block)
    end
  end

  def self.auth_patch *args, &block
    patch(*args) do
      authenticate!
      instance_eval(&block)
    end
  end

  def self.auth_delete *args, &block
    delete(*args) do
      authenticate!
      instance_eval(&block)
    end
  end

  def log message, level: :info
    MrMarkov.logger.send level, "[#{ logged_in? ? current_user : 'anonymous' }] - #{ message }"
  end
end
