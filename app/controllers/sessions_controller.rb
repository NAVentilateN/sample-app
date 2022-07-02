class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      log_in user
      redirect_to user
    else
      # include an error message
      flash.now[:danger] = "Incorrect email/password was provided"
      render 'new', status: :unprocessable_entity
    end
  end
  
  def destroy
    log_out
    redirect_to root_path, status: :see_other
    # status here is set as it does not redirect to a logout page but rather
    # redirect to another template page. In this case, it is our root_url
  end
  
  
  private
  
  def session_params
     params.require(:session).permit(:email, :password)
  end
end
