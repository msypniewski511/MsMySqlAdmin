class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'mysql2'
  after_action :close_connection, except:[:new]

  
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

  def use_database(database_name)
  	set_parameters
    @baza = Mysql2::Client.new(host: @host, username: @user, password: @password, database: database_name)
  end

  def close_database
  	@baza.close
  end
end
