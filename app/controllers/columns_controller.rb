class ColumnsController < ApplicationController
  before_action :use_database, except: [:new, :new_column]
  after_action :close_database, except: [:new, :new_column]

  # GET /databases/:database_id/tables/:table_id/columns
  def index
  	sql = "DESCRIBE #{params[:table_id].to_s}"
  	@describe = @baza.query(sql)
    respond_to do |format|
        format.html { }
        format.js { render :index }
    end
  end

  # GET /databases/:database_id/tables/:table_id/columns/:id
  def show
  	sql = "SHOW COLUMNS FROM #{params[:table_id]} FROM #{params[:database_id]} LIKE '#{params[:id]}'"
  	@column = @baza.query(sql)
    respond_to do |format|
        format.html { }
        format.js { render :show }
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
  	  sql = "SHOW COLUMNS FROM #{params[:table_id]} FROM #{params[:database_id]} LIKE '#{params[:id]}'"
  	  @column = @baza.query(sql)
      respond_to do |format|
        format.js{render :edit}
      end
  	rescue Mysql2::Error => e
  	  redirect_to :database_table_columns, notice: "#{e.to_s}"
  	end
  end

  # POST /databases/:database_id/tables/:table_id/columns
  # Add new column to the particular table.
  def create
  	begin
  	  parameters = column_attribute
  	  sql = "ALTER TABLE #{params[:table_id]} ADD COLUMN #{parameters}"
  	  @baza.query(sql)
      respond_to do |format|
        sql = "DESCRIBE #{params[:table_id].to_s}"
        @describe = @baza.query(sql)
        format.html {}
        format.js {render :index}
      end
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
  	  redirect_to :database_table_columns, notice: "Column added successfuly!"
  	rescue Mysql2::Error => e
  	  redirect_to :edit_database_table_column, notice: "#{e.to_s}"
  	end  	
  end

  # DELETE
  def destroy
  	begin
  	  sql = "ALTER TABLE #{params[:table_id]} DROP COLUMN #{params[:id]}"
  	  @baza.query(sql)
      sql = "DESCRIBE #{params[:table_id].to_s}"
      @describe = @baza.query(sql)
      flash.now[:notice] = "Column #{params[:id]} was deleted"
      my_redirect
  	rescue Mysql2::Error => e
  	  flash.now[:notice] = "#{e.to_s}"
      my_redirect
  	end
  end

  private
  def my_redirect
    respond_to do |format|
      sql = "DESCRIBE #{params[:table_id].to_s}"
      @describe = @baza.query(sql)
      format.html {}
      format.js {render :index}
    end
  end

  def column_attribute
  	@column_attribute = "#{params[:field]} #{params[:type]} #{params[:null]} #{params[:key]} #{params[:default]} #{params[:extra]}"
  end
end
#DEFAULT #{params[:default]} 
