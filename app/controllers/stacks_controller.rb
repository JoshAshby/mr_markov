class StacksController < BaseController
  auth_get '/stacks' do
    @stacks = current_user.stacks

    haml :'stacks/index'
  end

  auth_get '/stacks/:id' do
    @stack = Stack.find id: params['id']

    haml :'stacks/view'
  end
end
