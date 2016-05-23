module AuthenticationHelper
  def current_user
    @current_user ||= User.find id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end
end
