class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # once user arrived at this page, the user account will be activated.
    if user&& !user.activated? && user.authenticate?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
  private
end
