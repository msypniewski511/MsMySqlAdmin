class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'mysql2'
  after_action :close_connection, except:[:new]

  private
  def set_connection(host, user, password)
  	@client = Mysql2::Client.new(host: host, username: user, password: password)
  end
  def close_connection
  	@client.close()
  end
  def use_database(host, user, password, database_name)
    @baza = Mysql2::Client.new(host: host, username: user, password: password, database: database_name)
  end
end
