class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to databases_path
    else
      redirect_to login_url, allert: "Invalid user/password combination"
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_path, notice: "Logged out"
  end
end
