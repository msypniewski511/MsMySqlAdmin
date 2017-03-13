class DatabasesController < ApplicationController
  skip_after_action :close_connection, only:[:show]
  before_action :set_connection, expect: :show

  def server_info
    # information about server 
    begin
      @user = @client.query('SELECT USER()')
      @date = @client.query('SELECT CURRENT_DATE')
      @version = @client.query('SELECT VERSION()')
      @teraz = @client.query('SELECT NOW()')
      #@status = @client.query('SHOW STATUS')
      #@variable = @client.query('SHOW VARIABLES')
    rescue Msql2::Error => e
    end
  end

  def index
  	begin
      server_info
      @databases_list = @client.query('SHOW DATABASES')
    rescue Msql2::Error => e
    end
  end

  def show
  end

  def new
  end

  def create
  	begin
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
  	  sql = "DROP DATABASE #{params[:id].to_s}"
  	  @client.query(sql)
  	  redirect_to :databases, notice: "Dtadabase #{params[:id].to_s} droped successfuly"
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end
end
