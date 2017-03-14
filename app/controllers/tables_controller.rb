class TablesController < ApplicationController
  before_action :use_database, except: [:new, :new_column]
  after_action :close_database, except: [:new, :new_column]

  # GET /databases/database_id/tables
  # Show all tables in particular database
  def index
    begin
  	  @database_name = params[:database_id]
  	  sql = 'SHOW TABLES'
  	  @tables_list = @baza.query(sql)
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end

  # GET /databases/:database_id/tables/:id(.:format)
  # Show table common information and action on its
  def show
  end

  # GET /databases/:database_id/tables/new
  # Create form for new table.
  def new
  end

  # POST /databases/:database_id/tables
  # Craete new table in particular database.
  def create
  	begin
  	  sql = "CREATE TABLE #{params[:name].to_s} (#{params[:column_name].to_s} #{params[:type].to_s})"
  	  @baza.query(sql)
  	  redirect_to :database_tables, notice: "New table #{params[:name].to_s} was created"
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

  def edit
  end

  # DELETE /databases/:database_id/tables/:id
  # Delete table in particular database.
  def destroy
  	begin
  	  sql = "DROP TABLE #{params[:id]}"
  	  @baza.query(sql)
  	  redirect_to :database_tables, notice: "Table #{params[:id]} was successful deleted!"
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

  # GET /databases/:database_id/tables/:id/show_records
  #Show all records in table with id in particular database.
  def show_records
  	begin
  	  sql = "SELECT * FROM #{params[:id]}"
  	  @records = @baza.query(sql)
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

end
