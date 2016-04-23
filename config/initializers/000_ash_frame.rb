require 'ash_frame/block'
# require 'ash_frame/async'

# AshFrame.configure do |config|
#   config.async.sneakers = AshFrame.config_for(:sneakers).symbolize_keys
# end

# AshFrame::Async.setup!

if defined? ap
  def ap object, options={ indent: -2 }
    super
  end
end
