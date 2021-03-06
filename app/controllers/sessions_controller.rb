class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: session_params[:email].downcase)
    if @user&.authenticate(session_params[:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
          # for the else statement, it is in place
          # if user logged in again and the checkbox is unchecked
          # this will replace the previous login action
          # and update the database

        session_params[:remember_me] == "1" ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # include an error message
      flash.now[:danger] = "Incorrect email/password was provided"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
    # status here is set as it does not redirect to a logout page but rather
    # redirect to another template page. In this case, it is our root_url
  end


  private

  def session_params
     params.require(:session).permit(:email, :password, :remember_me)
  end
end
