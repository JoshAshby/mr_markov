class FramesController < BaseController
  auth_post '/frames' do
    stack = Stack.find id: params['stack']

    data = {
      processor: params['processor'],
      options: params['options']
    }

    stack.add_frame(**data)

    flash[:info] = "Successfully created frame"
    log "Createdd frame #{ frame.id }"

    redirect to("/stacks/#{ stack.id }")
  end

  auth_get '/frames/:id/edit' do
    @frame = Frame.find id: params['id']
    @processors = Processors.registry.map(&:first)

    haml :'frames/edit'
  end

  auth_post '/frames/:id/move_down' do
    frame = Frame.find id: params['id']

    frame.move_down

    flash[:info] = "Successfully moved frame down"
    log "Moved frame #{ frame.id } down to #{ frame.position }"

    redirect to("/stacks/#{ frame.stack_id }")
  end

  auth_post '/frames/:id/move_up' do
    frame = Frame.find id: params['id']

    frame.move_up

    flash[:info] = "Successfully moved frame up"
    log "Moved frame #{ frame.id } up to #{ frame.position }"

    redirect to("/stacks/#{ frame.stack_id }")
  end

  auth_post '/frames/:id' do
    frame = Frame.find id: params['id']

    data = {
      processor: params['processor'],
      options: params['options']
    }

    frame.update(**data)
    frame.save

    flash[:info] = "Successfully updated frame"
    log "Updated frame #{ frame.id }"

    redirect to("/stacks/#{ frame.stack_id }")
  end

  auth_delete '/frames/:id' do
    frame = Frame.find id: params['id']
    frame.destroy

    flash[:info] = "Successfully destroyed frame"
    log "Destroyed frame #{ frame.id }"

    redirect to("/stacks/#{ frame.stack_id }")
  end
end
