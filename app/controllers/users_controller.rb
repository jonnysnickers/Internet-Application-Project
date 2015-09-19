class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]
  
  #Shows only doctors
  def index
    @doctors = User.where(ttype: "doctor")
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if !@user[:enabled] 
      @user[:enabled] = "n"
    end
    if !@user[:ttype]
      @user[:ttype] = "patient"
    end
    if @user.save
      flash[:success] = 'Account created successfuly. Pleas wait for administrator confirmation.'
      redirect_to '/login'
      #redirect_to '/sign_in_success'
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:firstname, :lastname, :pesel, :address, :username, :password, :password_confirmation, :enabled, :ttype)
    end
  
  # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || logged_in_as_admin?
        flash[:danger] = "It looks like you don't have permission to enter this content."
        redirect_to(root_url)
      end
    end
  
end
