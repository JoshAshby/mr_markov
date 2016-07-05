require_relative 'mr_markov'
require_rel %w| config/initializers lib app/helpers app/presenters app/controllers |

map '/' do
  run ApplicationController
end

trap("INT"){ exit }
