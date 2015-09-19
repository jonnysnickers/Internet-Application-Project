class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password]) && user.enabled == 'y'
      log_in user
      redirect_back_or user
    else
      if user && user.enabled != 'y'
        flash.now[:danger] = 'Your account is not enabled yet.'
      else
        flash.now[:danger] = 'Invalid username/password combination'
      end
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
  
end
