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
    respond_to do |format|
        format.html { }
        format.js { render :index }
    end
  	rescue Mysql2::Error => e
  	  redirect_to :databases, notice: "#{e.to_s}"
  	end
  end

  # GET /databases/:database_id/tables/:id(.:format)
  # Show table common information and action on its
  def show
    respond_to do |format|
      format.html
      format.js{}
    end
  end

  # GET /databases/:database_id/tables/new
  # Create form for new table.
  def new
    respond_to do |format|
      format.js {render :new}
    end
  end

  # GET /databases/:database_id/tables/:id/edit
  # Create new form to rename table
  def edit
    begin
      sql = "DESCRIBE #{params[:id].to_s}"
      @describe = @baza.query(sql)
      respond_to do |format|
        format.html {}
        format.js { render :edit }
      end
    rescue Mysql2::Error => e
      redirect_to :database_tables_path
    end
  end

  # POST /databases/:database_id/tables
  # Craete new table in particular database.
  def create
  	begin
  	  sql = "CREATE TABLE #{params[:name].to_s} (#{params[:field].to_s} #{params[:type].to_s})"
  	  @baza.query(sql)
      respond_to do |format|
        format.js{render :index}
        sql = 'SHOW TABLES'
        @tables_list = @baza.query(sql)
        ActionCable.server.broadcast 'tables', html: render_to_string('tables/index', layout: false)
      end
  	  #redirect_to :database_tables, notice: "New table #{params[:name].to_s} was created"
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

  def update
    begin
      sql = "ALTER TABLE #{params[:id].to_s} RENAME #{params[:new_name].to_s}"
      @baza.query(sql)
      respond_to do |format|
        format.js{render :index}
        sql = 'SHOW TABLES'
        @tables_list = @baza.query(sql)
        ActionCable.server.broadcast 'tables', html: render_to_string('tables/index', layout: false)
      end
    rescue Mysql2::Error => e
      redirect_to :database_tables, notice: "#{e.to_s}"
    end
  end
  # DELETE /databases/:database_id/tables/:id
  # Delete table in particular database.
  def destroy
  	begin
  	  sql = "DROP TABLE #{params[:id]}"
  	  @baza.query(sql)
      sql = 'SHOW TABLES'
      @tables_list = @baza.query(sql)
      respond_to do |format|
        format.js { render :index}
      end
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
      respond_to do |format|
        format.js { render :show_records }
      end
  	rescue Mysql2::Error => e
  	  redirect_to :database_tables, notice: "#{e.to_s}"
  	end
  end

end
