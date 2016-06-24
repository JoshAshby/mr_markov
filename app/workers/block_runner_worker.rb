class BlockRunnerWorker < Worker
  set_asyncer do |packet|
    BlockRunnerWorker.new.async.work packet
  end

  set_scheduler do |packet, run_at:, day_mask:, repeat:|
    Chronotrigger.create name: SecureRandom.hex,
        run_at: Time.parse(run_at).utc.strftime('%R'),
        day_mask: day_mask.to_s,
        repeat: repeat,
        job_klass: :BlockRunnerWorker,
        job_function: :work,
        job_arguments: packet
  end

  def perform block_klass:, **opts
    klass = Object.const_get block_klass

    klass.call(**opts)
  end
end
