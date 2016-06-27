class FramesController < BaseController
  auth_post '/frames' do
    stack = Stack.find id: params['stack']
    stack.add_frame(**data)

    flash[:info] = "Successfully created frame"

    redirect to("/stacks/#{ stack.id }")
  end

  auth_get '/frames/:id/edit' do
    @frame = Frame.find id: params['id']

    haml :'frames/edit'
  end

  auth_post '/frames/:id' do
    frame = Frame.find id: params['id']

    frame.update(**data)
    frame.save

    flash[:info] = "Successfully updated frame"

    redirect to("/stacks/#{ frame.stack_id }")
  end

  auth_delete '/frames/:id' do
    frame = Frame.find id: params['id']
    frame.destroy

    flash[:info] = "Successfully destroyed frame"

    redirect to("/stacks/#{ frame.stack_id }")
  end
end
