require_relative 'mr_markov'
# require 'opal'

# opal = Opal::Server.new {|s|
#   s.append_path 'app'
#   s.main = 'application'
# }

# map opal.source_maps.prefix do
#   run opal.source_maps
# end

# map '/assets' do
#   run opal.sprockets
# end

map '/' do
  run ApplicationController
end

trap("INT"){ exit }
