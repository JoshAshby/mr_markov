class BlockRunnerWorker < Worker
  set_asyncer do |packet|
    BlockRunnerWorker.new.async.work packet
  end

  set_scheduler do |packet, start_time:, repeat_delta:|
    Chronotrigger.create name: SecureRandom.hex,
        last_ran: start_time.to_i,
        repeat_delta: repeat_delta.to_i,
        job_klass: :BlockRunnerWorker,
        job_function: :work,
        job_arguments: packet
  end

  def perform block_klass:, **opts
    klass = Object.const_get block_klass

    klass.call(**opts)
  end
end
