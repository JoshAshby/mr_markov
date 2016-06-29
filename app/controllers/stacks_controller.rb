class StacksController < BaseController
  auth_get '/stacks' do
    @stacks = current_user.stacks.map{ |s| StackPresenter.new s }

    haml :'stacks/index'
  end

  auth_post '/stacks' do
    stack = current_user.add_stack name: params['name']

    flash[:info] = "Successfully created stack"
    log "Created stack #{ stack.id }"

    redirect to("/stacks/#{ stack.id }")
  end

   auth_get '/stacks/:id' do
    @stack = StackPresenter.new Stack.find(id: params['id'])

    haml :'stacks/view'
  end

  auth_get '/stacks/:id/chronotriggers' do
    @stack = StackPresenter.new Stack.find(id: params['id'])

    haml :'stacks/chronotriggers'
  end

  auth_get '/stacks/:id/edit' do
    @stack = StackPresenter.new Stack.find(id: params['id'])

    haml :'stacks/edit'
  end

  auth_post '/stacks/:id' do
    stack = Stack.find id: params['id']
    stack.update name: params['name']

    flash[:info] = "Successfully updated stack"
    log "Updated stack #{ stack.id }"

    redirect to("/stacks/#{ stack.id }")
  end

  auth_delete '/stacks/:id' do
    stack = Stack.find id: params['id']
    stack.destroy

    flash[:info] = "Successfully destroyed stack"
    log "Destroyed stack #{ stack.id }"

    redirect to("/stacks")
  end

  auth_get '/stacks/:id/frames/new' do
    @stack = StackPresenter.new Stack.find(id: params['id'])
    @frame = Frame.new stack: @stack
    @processors = Processors.registry.map(&:first)

    haml :'frames/new'
  end

  auth_get '/stacks/:id/chronotriggers/new' do
    @stack = StackPresenter.new Stack.find(id: params['id'])
    @chronotrigger = Chronotrigger.new stack: @stack, day_mask: '0111110', repeat: 1, run_at: @timezone.now.utc.strftime('%R')

    haml :'chronotriggers/new'
  end
end
