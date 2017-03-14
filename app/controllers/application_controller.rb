class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'mysql2'

  
  private
  def set_parameters
  	@host = "localhost"
  	@user = "root"
  	@password = "Ms55015501"
  end

  def set_connection()
  	set_parameters
  	@client = Mysql2::Client.new(host: @host, username: @user, password: @password)
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
