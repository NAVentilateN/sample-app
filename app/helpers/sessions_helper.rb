module SessionsHelper
  
  # Including method here allow method to be used for sessions controller.
  # Including this helper into application controller allow method to be used throughout the entire application
  
  def log_in(user)
    # session is a method in rails that create a temporary cookie that will be deleted when the browser is close
    session[:user_id] = user.id
  end
  
  def current_user
    # this is a or equal operator
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    # session[:user_id] = nil
    reset_session
    @current_user = nil
  end
end
