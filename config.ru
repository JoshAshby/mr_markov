require_relative 'mr_markov'
require_rel %w| config/initializers lib app/helpers app/presenters app/controllers |

map '/' do
  run ApplicationController
end

class WorkerScheduler < Scheduler
  def on_tick
    RunActiveChronotriggersWorker.perform_async
  end
end

WorkerScheduler.new.async.start!

trap("INT"){ exit }
