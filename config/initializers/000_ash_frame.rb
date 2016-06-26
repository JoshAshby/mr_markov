require 'ash_frame/block'
require 'ash_frame/worker'

if defined? ap
  def ap object, options={ indent: -2 }
    super
  end
end
