class DatabasesController < ApplicationController
  after_action :close_connection, expect: [:show, :new, :index]
  skip_after_action :close_connection, only: :index
  before_action :set_connection, expect: [:show, :new, :index, :server_details]
  skip_before_action :set_connection, only: :index

  def change_server
    session[:status_connection] = nil
    render :index
  end

  def server_details
    set_session_parameters
    set_connection
    redirect_to :databases
  end

  #GET /databases/server_info
  # information about server
  def server_info
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

  # GET /databases
  # Get basic server info and databases list.
  def index
    if(session[:password] != nil)then
      @pas = session[:password]
    else
      @pas = "brak hasla"
    end
    
    if(session[:status_connection] == "ok") then
  	  begin
        set_connection
        server_info
        @databases_list = @client.query('SHOW DATABASES')
      rescue
        render :index
      end
    end
  end

  # GET /databases/:id
  def show
    respond_to do |format|
      format.js {}
      format.html{}
    end
  end

  # GET /databases/new
  # Create form for new database.
  def new
    respond_to do |format|
      format.html {}
      format.js { render :new }
    end
  end

  # POST /databases
  # Create new database
  def create
  	begin
  	  @new_database = params[:name]
  	  sql = "CREATE DATABASE #{@new_database.to_s}"
  	  @client.query(sql)
  	  redirect_to :databases
    rescue Mysql2::Error => e
      flash.now[:notice] = "#{e.to_s}"
      render :new, remote: true
    end
  end

  # DELETE /databases/:id
  # Delete particular database
  def destroy
  	begin
  	  sql = "DROP DATABASE #{params[:id].to_s}"
  	  @client.query(sql)
  	  redirect_to :databases, notice: "Dtadabase #{params[:id].to_s} droped successfuly"
  	rescue Mysql2::Error => e
      flash.now[:notice] = "#{e.to_s}"
  	  redirect_to :databases
  	end
  end

  private
  def set_session_parameters
    session[:host] = params[:host]
    session[:user_server] = params[:user_server]
    session[:password] = params[:password]
  end
end
