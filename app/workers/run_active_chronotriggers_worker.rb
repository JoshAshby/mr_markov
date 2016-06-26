class RunActiveChronotriggersWorker < AshFrame::Worker
  include Celluloid

  set_asyncer do |packet|
    self.new.async.work packet
  end

  def perform
    MrMarkov.logger.debug "Loading chronotriggers ..."

    chronotriggers = Chronotrigger.active.to_a.select(&:should_run?)

    chronotriggers.each do |chronotrigger|
      MrMarkov.logger.debug "Running chronotrigger #{ chronotrigger.id }"

      RunStackBlock[ stack: chronotrigger.stack, event: chronotrigger.event ]

      chronotrigger.update last_ran: Date.current
      chronotrigger.save
    end
  end
end
