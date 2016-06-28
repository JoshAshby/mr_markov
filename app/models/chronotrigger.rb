class Chronotrigger < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :stack

  def validate
    super
    validates_presence [ :stack_id, :name, :run_at ]
  end

  subset :active do
    "(day_mask & B'#{ Chronotrigger.current_day_mask }')::integer != 0 AND run_at < '#{ Time.current.strftime('%T') }' AND (last_ran != '#{ Time.current.strftime('%F') }' OR last_ran IS NULL)"
  end

  def should_run?
    return true if last_ran.nil?

    days_difference  = (last_ran.beginning_of_week - Date.current.beginning_of_week).abs.floor
    weeks_difference = days_difference / 7

    MrMarkov.logger.debug "Chronotrigger #{ id } has days_difference #{ days_difference } and week_difference #{ weeks_difference } and repeat #{ repeat }"

    return true  if weeks_difference == 0
    return false if weeks_difference > 0 && repeat == 0
    return false if weeks_difference < repeat

    true
  end

  def self.current_day_mask
    day_mask = [].fill(0, 0, 7)
    day_mask[Date.current.wday] = 1
    day_mask.join
  end
end
