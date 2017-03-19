class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'mysql2'
  before_action :authorize

  
  private
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to root_path, notice: "Please log in"
    end
  end

  def set_parameters
      @host = session[:host]
      @user = session[:user_server]
      @password = session[:password]
  end

  def set_connection()
    begin
  	  #set_parameters
  	  @client = Mysql2::Client.new(host: session[:host], username: session[:user_server], password: session[:password])
      #session variable will be use to check the server connect info are corect.
      session[:status_connection] = "ok"
    rescue Mysql2::Error => e
      #session[:user_server] = ""
      #session[:host] = ""
      #session[:password] =""
      session[:status_connection] = ""
      #redirect_to databases_path, notice: "Invalid user/host/password #{e.to_s}", remote: true
    end
  end

  def close_connection
  	@client.close()
  end

  def use_database
  	set_parameters
    @baza = Mysql2::Client.new(host: @host, username: @user, password: @password, database: params[:database_id])
  end

  def close_database
  	@baza.close
  end
end