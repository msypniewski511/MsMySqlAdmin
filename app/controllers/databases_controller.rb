class DatabasesController < ApplicationController
  after_action :close_connection, expect:[:show, :new]
  before_action :set_connection, expect: [:show, :new]

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
  	begin
      server_info
      @databases_list = @client.query('SHOW DATABASES')
    rescue Msql2::Error => e
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

end
