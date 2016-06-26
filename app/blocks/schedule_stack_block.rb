class ScheduleStackBlock < AshFrame::Block
  require :stack, :event, :run_at, :day_mask, :repeat
  optional name: -> { SecureRandom.hex }

  def logic
    trigger = stack.add_chronotrigger name: name,
                                      event: event,
                                      run_at: run_at,
                                      day_mask: day_mask,
                                      repeat: repeat

    trigger.save
  end
end
