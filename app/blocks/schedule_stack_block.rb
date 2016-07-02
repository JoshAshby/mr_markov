class ScheduleStackBlock < AshFrame::Block
  require :stack, :event, :run_at, :day_mask

  optional name: -> { SecureRandom.hex },
           timezone: 'Etc/UTC',
           repeat: 1

  def logic
    trigger = stack.add_chronotrigger name: name,
                                      event: event,
                                      run_at: run_at,
                                      day_mask: day_mask,
                                      repeat: repeat,
                                      timezone: timezone

    trigger.save
  end
end
