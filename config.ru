require_relative 'mr_markov'

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
