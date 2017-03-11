class DatabasesController < ApplicationController
  skip_after_action :close_connection, only:[:show]

  def index
  	set_connection("localhost", "root", "Ms55015501")
  	# information about server 
  	begin
      @user = @client.query('SELECT USER()')
      @date = @client.query('SELECT CURRENT_DATE')
      @version = @client.query('SELECT VERSION()')
      @teraz = @client.query('SELECT NOW()')
      @databases_list = @client.query('SHOW DATABASES')
    rescue Msql2::Error => e
    end
  end

  def show
  	begin
  	  @database_name = params[:id]
  	  use_database("localhost", "root", "Ms55015501", @database_name.to_s)
  	  sql = 'SHOW TABLES'
  	  @tables_list = @baza.query(sql)
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end

  def new
  end

  def create
  	begin
  	  set_connection("localhost", "root", "Ms55015501")
  	  @new_database = params[:name]
  	  sql = "CREATE DATABASE #{@new_database.to_s}"
  	  @client.query(sql)
  	  redirect_to :databases
    rescue Mysql2::Error => e
  	  redirect_to :new_database, notice: "#{e.to_s}"
    end
  end

  def destroy
  	begin
  	  set_connection("localhost", "root", "Ms55015501")
  	  sql = "DROP DATABASE #{params[:id]}"
  	  @client.query(sql)
  	  redirect_to :databases, notice: "Dtadabase #{params[:id].to_s} droped successfuly"
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end
end
