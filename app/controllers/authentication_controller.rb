class AuthenticationController < BaseController
  get '/login' do
    return haml :login unless logged_in?

    session.delete :return_path
    redirect to('/')
  end

  post '/login' do
    identity = params['username'].downcase

    user = User.find{ lower(username) =~ identity }

    if user.blank?
      flash.now[:error] = "User or Password does not match"
      halt haml :login
    end

    unless user.authenticate(params['password'])
      flash.now[:error] = "User or Password does not match"
      halt haml :login
    end

    session[:user_id] = user.id
    @current_user = user

    path = session[:return_path] || '/'
    redirect to(path)
  end

  get '/logout' do
    session.delete :user_id

    redirect to('/')
  end
end
