class Chronotrigger < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :stack

  def validate
    super
    validates_presence [ :stack_id, :name, :run_at ]
  end

  def should_run?
    return true if last_ran.nil?

    current_timezone = ActiveSupport::TimeZone[ timezone ]
    current_datetime = Time.current.in_time_zone current_timezone

    MrMarkov.logger.debug "Chronotrigger #{ id }: current time: #{ current_datetime } and last ran #{ last_ran } and run at #{ run_at }"

    return false if day_mask.chars[ current_datetime.wday ] == "0"
    return false if run_at.strftime('%T') > current_datetime.strftime('%T')
    return false if last_ran == current_datetime.to_date

    days_difference  = (last_ran.beginning_of_week - current_datetime.beginning_of_week.to_date).abs.floor
    weeks_difference = days_difference / 7

    MrMarkov.logger.debug "Chronotrigger #{ id }: days difference #{ days_difference } and week difference #{ weeks_difference } and week repeat #{ repeat }"

    return true  if weeks_difference == 0
    return false if weeks_difference > 0 && repeat == 0
    return false if weeks_difference < repeat

    true
  end

  def ran!
    current_timezone = ActiveSupport::TimeZone[ timezone ]
    current_datetime = Time.current.in_time_zone current_timezone

    update last_ran: current_datetime.to_date
  end
end
