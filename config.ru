require_relative 'mr_markov'

map '/' do
  run ApplicationController
end

trap("INT"){ exit }
