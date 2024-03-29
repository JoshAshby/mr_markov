class ChronotriggersController < BaseController
  auth_post '/chronotriggers' do
    day_mask = build_day_mask params['day_mask']

    data = {
      run_at: params['run_at'],
      day_mask: day_mask,
      repeat: params['repeat'].to_i,
      timezone: params['run_at_tz'],
      name: params['name'],
      event: {}
    }

    stack = Stack.find id: params['stack']
    trigger = stack.add_chronotrigger(**data)

    flash[:info] = "Successfully created chronotrigger"
    log "Created chronotrigger #{ trigger.id }"

    redirect to("/stacks/#{ stack.id }/chronotriggers")
  end

  auth_get '/chronotriggers/:id/edit' do
    @chronotrigger = Chronotrigger.find id: params['id']

    haml :'chronotriggers/edit'
  end

  auth_post '/chronotriggers/:id' do
    trigger = Chronotrigger.find id: params['id']

    day_mask = build_day_mask params['day_mask']

    data = {
      run_at: params['run_at'],
      day_mask: day_mask,
      repeat: params['repeat'].to_i,
      timezone: params['run_at_tz'],
      name: params['name'],
      event: {}
    }

    trigger.update(**data)
    trigger.save

    flash[:info] = "Successfully updated chronotrigger"
    log "Updated chronotrigger #{ trigger.id }"

    redirect to("/stacks/#{ trigger.stack_id }/chronotriggers")
  end

  auth_delete '/chronotriggers/:id' do
    trigger = Chronotrigger.find id: params['id']
    trigger.destroy

    flash[:info] = "Successfully destroyed chronotrigger"
    log "Destroy chronotrigger #{ trigger.id }"

    redirect to("/stacks/#{ trigger.stack_id }/chronotriggers")
  end

  protected

  def build_day_mask day_mask_param, days_of_week: %w| sunday monday tuesday wednesday thursday friday saturday |
    day_mask = [].fill(0, 0, 7)

    day_mask_param.each do |day|
      idx = days_of_week.index day
      day_mask[idx] = 1
    end

    day_mask.join
  end
end
