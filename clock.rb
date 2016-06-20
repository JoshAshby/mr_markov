require_relative './mr_markov'

class Scheduler
  include Celluloid

  def initialize
    @chronotriggers = {}
    @timer = nil
  end

  def start!
    @timer = every(1.minutes) do
      perform_tasks
    end
  end

  def stop!
  end

  def sync_db
    @chronotriggers = Chronotrigger.all.inject({}) do |memo, chronotrigger|
      memo[chronotrigger] = chronotrigger.next_run chronotrigger.run_time
      memo
    end
  end

  def perform_tasks
    @chronotriggers.select do |chronotrigger, next_run|
      next unless Time.now >= next_run

      block_class = Object.const_get chronotrigger.job_klass
      args = Marshal.load chronotrigger.job_arguments

      block_class.async_call *args

      @chronotriggers[chronotrigger] = Time.now + chronotrigger.next_run
    end
  end
end

s = Scheduler.new
s.start!

debugger

puts
