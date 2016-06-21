class Scheduler
  include Celluloid
  attr_reader :timer

  def initialize
    @timer = nil
  end

  def start!
    perform_tasks

    @timer = every(1.minutes) do
      perform_tasks
    end
  end

  def stop!
    @timer.cancel
  end

  def perform_tasks
    MrMarkov.logger.debug "Loading chronotriggers ..."
    chronotriggers = Chronotrigger.where{ last_ran + repeat_delta <= Time.current.to_i }

    chronotriggers.each do |chronotrigger|
      MrMarkov.logger.debug "Running chronotrigger for #{ chronotrigger.job_klass }"

      klass = Object.const_get chronotrigger.job_klass

      klass.new.send chronotrigger.job_function, chronotrigger.job_arguments

      chronotrigger.update last_ran: Time.current.to_i
      chronotrigger.save
    end
  end
end
