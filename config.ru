require_relative 'mr_markov'

run Rack::URLMap.new('/' => ApplicationController)

trap("INT"){ exit }
