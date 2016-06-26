class ChronotriggersController < BaseController
  auth_post '/chronotriggers' do
    run_at_time = build_utc_time params['run_at'], params['run_at_tz']

    day_mask = build_day_mask params['day_mask']

    data = {
      run_at: run_at_time,
      day_mask: day_mask,
      repeat: params['repeat'].to_i,
      name: params['name'],
      event: {}
    }

    stack = Stack.find id: params['stack']

    stack.add_chronotrigger(**data)

    flash[:info] = "Successfully created chronotrigger"

    redirect to("/stacks/#{ stack.id }")
  end

  auth_delete '/chronotriggers/:id' do
    trigger = Chronotrigger.find(id: params['id'])
    trigger.destroy

    flash[:info] = "Successfully destroyed chronotrigger"

    redirect to("/stacks/#{ trigger.stack_id }")
  end

  protected

  def build_utc_time time, tz
    timezone = ActiveSupport::TimeZone.find_tzinfo tz
    timezone.local_to_utc Time.parse(time)
  end

  def build_day_mask day_mask_param, days_of_week: %w| sunday monday tuesday wednesday thursday friday saturday |
    day_mask = [].fill(0, 0, 7)

    day_mask_param.each do |day|
      idx = days_of_week.index day
      day_mask[idx] = 1
    end

    day_mask.join
  end
end
