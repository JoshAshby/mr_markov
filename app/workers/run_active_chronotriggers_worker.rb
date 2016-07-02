class RunActiveChronotriggersWorker < AshFrame::Worker
  include Celluloid

  set_asyncer do |packet|
    self.new.async.work packet
  end

  def perform
    MrMarkov.logger.debug "Loading chronotriggers ..."

    Chronotrigger.dataset.order(:id).each do |chronotrigger|
      unless chronotrigger.should_run?
        MrMarkov.logger.debug "Not running chronotrigger #{ chronotrigger.id } because its should_run? returned false"
        next
      end

      MrMarkov.logger.debug "Running chronotrigger #{ chronotrigger.id }"

      RunStackBlock[ stack: chronotrigger.stack, event: chronotrigger.event ]

      chronotrigger.ran!
      chronotrigger.save
    end
  end
end
