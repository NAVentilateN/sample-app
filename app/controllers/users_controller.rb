class UsersController < ApplicationController
  # to include check that the user is already logged in to access the following site
  before_action :logged_in_user, only: [:index, :edit, :show, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: :destroy
  before_action :set_user, only: [:edit, :update, :show, :destroy, :following, :followers]
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      reset_session
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
       flash[:success] = "Updated User profile"
       redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  
  def following
    @title = "Following"
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    # we can't use @user yet as action is performed before the controller action.
    # thus @user have not be instantiate
    @user = User.find(params[:id])
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
