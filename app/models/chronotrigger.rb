class Chronotrigger < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :stack

  def validate
    super
    validates_presence [ :stack_id, :name, :run_at ]
  end

  subset :active do
    "(day_mask & B'#{ Chronotrigger.current_day_mask }')::integer != 0 AND run_at < CURRENT_TIME AND (last_ran != CURRENT_DATE OR last_ran IS NULL)"
  end

  def should_run?
    return true if last_ran.nil?

    days_difference  = (last_ran.at_beginning_of_week - Date.current.at_beginning_of_week).abs.floor
    weeks_difference = days_difference / 7

    return true  if weeks_difference == 0
    return false if weeks_difference > 0 && repeat == 0
    return false if weeks_difference < repeat
  end

  def self.current_day_mask
    day_mask = [].fill(0, 0, 7)
    day_mask[Date.current.wday] = 1
    day_mask.join
  end
end
