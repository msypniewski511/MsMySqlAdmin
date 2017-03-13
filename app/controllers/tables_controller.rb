class TablesController < ApplicationController
  skip_after_action :close_connection
  after_action :close_database, except: [:new, :new_column]

  # GET /databases/database_id/tables
  # Show all tables in particular database
  def index
    begin
  	  @database_name = params[:database_id]
  	  use_database(params[:database_id])
  	  sql = 'SHOW TABLES'
  	  @tables_list = @baza.query(sql)
  	  @baza.close()
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end

  # GET /databases/:database_id/tables/:id(.:format)
  # Show table description
  def show
  	begin
  	  use_database(params[:database_id])
  	  sql = "DESCRIBE #{params[:id].to_s}"
  	  @describe = @baza.query(sql)
  	  @baza.close()
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

  # GET /databases/:database_id/tables/new
  # Create form for new table.
  def new
  end

  # GET /databases/:database_id/tables/:id/new_column
  # Create form for new columns.
  def new_column
  end

  # POST /databases/:database_id/tables
  # Craete new table in particular database.
  def create
  	begin
  	  use_database(params[:database_id])
  	  sql = "CREATE TABLE #{params[:name].to_s} (#{params[:column_name].to_s} #{params[:type].to_s})"
  	  @baza.query(sql)
  	  @baza.close()
  	  redirect_to :database_tables, notice: "New table #{params[:name].to_s} was created"
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

  # POST /databases/:database_id/tables/:id/add_column
  # Add new column to the particular table.
  def add_column
  	use_database(params[:database_id])
  	sql = "ALTER TABLE #{params[:id]} ADD COLUMN #{params[:column_name].to_s} #{params[:type].to_s}"
  	@baza.query(sql)
  	redirect_to :database_table
  end

  def edit
  end

  # DELETE /databases/:database_id/tables/:id
  # Delete table in particular database.
  def destroy
  	begin
  	  use_database(params[:database_id])
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
  	  use_database(params[:database_id])
  	  sql = "SELECT * FROM #{params[:id]}"
  	  @records = @baza.query(sql)
  	rescue Mysql2::Error => e
  		redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

end
