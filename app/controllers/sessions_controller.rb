class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:status] = "badddd"
      session[:status_connection_info] = "bad"
      redirect_to databases_path
    else
      redirect_to login_url, allert: "Invalid user/password combination"
    end
  end

  def destroy
  	session[:user_id] = nil
    session[:host] = nil
    session[:user_server] = nil
    session[:status] = "wyjscie z zalog status/n"
    session[:password] = ""
  	redirect_to root_path, notice: "Logged out"
  end
end
