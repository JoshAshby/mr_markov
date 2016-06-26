class StacksController < BaseController
  auth_get '/stacks' do
    @stacks = current_user.stacks.map{ |s| StackPresenter.new s }

    haml :'stacks/index'
  end

  auth_get '/stacks/:id' do
    @stack = StackPresenter.new Stack.find(id: params['id'])

    haml :'stacks/view'
  end

  auth_get '/stacks/:id/chronotriggers/new' do
    @stack  = StackPresenter.new Stack.find(id: params['id'])
    @stacks = current_user.stacks.map{ |s| StackPresenter.new s }

    haml :'stacks/new_chronotrigger'
  end
end
