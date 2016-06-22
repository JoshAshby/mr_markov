class Scheduler
  include Celluloid
  attr_reader :timer

  def initialize tick: 1.minutes
    @timer = nil
    @tick  = tick
  end

  def start!
    perform_tasks

    @timer = every(@tick) do
      on_tick
    end
  end

  def stop!
    @timer.cancel
  end

  def on_tick
  end
end
