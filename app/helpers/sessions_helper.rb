module SessionsHelper
  
  # Including method here allow method to be used for sessions controller.
  # Including this helper into application controller allow method to be used throughout the entire application
  
  def log_in(user)
    # session is a method in rails that create a temporary cookie that will be deleted when the browser is close
    session[:user_id] = user.id
     # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
    
  end
  
  def remember(user)
    user.remember
    cookie_save(user)
  end
  
  def current_user
    # this is a or equal operator
    # this is an assignment not a comparator. this is just to remove duplication
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # user = User.find_by(id: user_id)
      # if user && session[:session_token] == user.session_token
      #   @current_user = user
      # end
    # to pull out a signed cookie
    elsif (user_id = cookies.encrypted[:user_id])
      #  as we do not have a user instance yet, the only way to find the user
      # is based on how we store the user information in 
      # as part of the remember method
      user = User.find_by(id: user_id)
      # next we will automatically check and authenticate the user into an existing session
      if user &.authenticate?(cookies[:remember_token])
        log_in user
         @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    # session[:user_id] = nil
    forget current_user
    reset_session
    @current_user = nil
  end
  
  def forget(user)
    # remove permanent cookie from browser
    # clear remember digest and remember token
    user.forget
    cookie_delete(user)
    user.remember_token = nil
  end
  
  def cookie_save(user)
    # this will set a permanent (20.years.from_now.utc) and also 
    # encrypt the user id before generating the cookie
    cookies.permanent.encrypted[:user_id] = user.id
    
    # the cookie remember token is already a random string. So there isn't
    # a need to signed the cookie.
    # this remember token will be used to compare with the remember_digest token
    # in the user database to authenticate the user
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def cookie_delete(user)
    # whatever was saved in the cookie should be deleted
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
