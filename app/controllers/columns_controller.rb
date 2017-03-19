class ColumnsController < ApplicationController
  before_action :use_database, except: [:new]
  after_action :close_database, except: [:new]

  # GET /databases/:database_id/tables/:table_id/columns
  # List columns in particular table
  def index
  	my_redirect
  end

  # GET /databases/:database_id/tables/:table_id/columns/:id
  # Show list attributes of column
  def show
    begin
  	  show_column
      respond_to do |format|
        format.html { }
        format.js { render :show }
      end
    rescue Mysql2::error => e
      my_redirect
    end
  end

  # GET /databases/:database_id/tables/:table_id/columns/new
  # Create form for new columns.
  def new
    respond_to do |format|
      format.html {}
      format.js
    end
  end

  #GET /databases/:database_id/tables/:table_id/columns/:id/edit
  # Create form for edit column.
  def edit
  	begin
  	  show_column
      respond_to do |format|
        format.js{render :edit}
      end
  	rescue Mysql2::Error => e
  	  flash.now[:notice] = "#{e.to_s}"
      my_redirect
  	end
  end

  # POST /databases/:database_id/tables/:table_id/columns
  # Add new column to the particular table.
  def create
  	begin
  	  parameters = column_attribute
  	  sql = "ALTER TABLE #{params[:table_id]} ADD COLUMN #{parameters}"
  	  @baza.query(sql)
      flash[:notice] = "Column: #{parameters[params[:field]].to_s} added successfuly!"
      my_redirect
  	  #redirect_to :database_table_columns, notice: "Column added successfuly!"
  	rescue Mysql2::Error => e
  	  redirect_to :new_database_table_column, notice: "#{e.to_s}"
  	end
  end

  # PUT
  def update
  	begin
  	  parameters = column_attribute
  	  sql = "ALTER TABLE #{params[:table_id]} CHANGE #{params[:id]} #{params[:field]} #{params[:type]} #{params[:key]} #{params[:null]} #{params[:extra]}"
  	  @baza.query(sql)
  	  flash.now[:notice] = "Changes was successfuly saved"
      my_redirect
  	rescue Mysql2::Error => e
      show_column
      flash.now[:notice] = "#{e.to_s}"
      respond_to do |format|
        format.js {render :edit}
      end
  	  #redirect_to :edit_database_table_column, notice: "#{e.to_s}"
  	end  	
  end

  # DELETE
  def destroy
  	begin
  	  sql = "ALTER TABLE #{params[:table_id]} DROP COLUMN #{params[:id]}"
  	  @baza.query(sql)
      flash.now[:notice] = "Column #{params[:id]} was deleted"
      my_redirect
  	rescue Mysql2::Error => e
  	  flash.now[:notice] = "#{e.to_s}"
      my_redirect
  	end
  end#return index

  private

  # Redirect to index template to list columns in table
  def my_redirect
    sql = "DESCRIBE #{params[:table_id].to_s}"
    @describe = @baza.query(sql)
    respond_to do |format|
      format.html {}
      format.js {render :index}
    end
  end

  # Return instance variable with attributes and values
  def show_column
    sql = "SHOW COLUMNS FROM #{params[:table_id]} FROM #{params[:database_id]} LIKE '#{params[:id]}'"
    @column = @baza.query(sql)
  end

  def column_attribute
  	@column_attribute = "#{params[:field]} #{params[:type]} #{params[:null]} #{params[:key]} #{params[:default]} #{params[:extra]}"
  end
end
#DEFAULT #{params[:default]} 
