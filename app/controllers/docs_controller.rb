class DocsController < ApplicationController
  before_filter :is_login
  
  def db_init
    config = Rails.configuration.database_configuration
    servername = config[Rails.env]["host"]
    dbname = config[Rails.env]["database"]
    serveruser = config[Rails.env]["username"]
    serverpw = config[Rails.env]["password"]

    @con = Mysql.new servername, serveruser, serverpw, dbname
  end

  def is_login
    if cookies['membership'] != "user" then
      redirect_to('/')
    end
  end

  before_action :set_doc, only: [:show, :edit, :update, :destroy]
  # before_action :set_id, only: [:sendtest]

  def sendtest
    db_init
    begin
      pstmt = @con.prepare "SELECT now_history_id FROM docs WHERE id = ?"
      pstmt.execute params[:doc_id]
      hid = pstmt.fetch[0]

      pstmt = @con.prepare "SELECT login_email FROM users WHERE id = ?"
      pstmt.execute cookies['id']
      history_email = pstmt.fetch[0]
      history_timestamp = Time.now.to_s

      pstmt = @con.prepare "INSERT INTO docs_histories (docs_id, description, by_user_id, by_user_email) VALUES (?, ?, ?, (SELECT login_email FROM users WHERE id = ?))"
      pstmt.execute params[:doc_id], history_timestamp, cookies['id'], cookies['id']

      pstmt = @con.prepare "SELECT auto_Increment FROM INFORMATION_SCHEMA.tables WHERE table_name='docs_histories'"
      pstmt.execute
      now_hid = pstmt.fetch[0]-1
    
      pstmt = @con.prepare "UPDATE docs SET now_history_id = ? WHERE id = ?"
      pstmt.execute now_hid, params[:doc_id]
      
      unless hid == nil
        pstmt = @con.prepare "UPDATE docs_histories SET prev_history_id = ? WHERE id = ?"
        pstmt.execute hid, now_hid
        
        pstmt = @con.prepare "UPDATE docs_histories SET next_history_id = ? WHERE id = ?"
        pstmt.execute now_hid, hid
      end

      file_path = "#{Rails.root}/public/history_data/"
      Dir.mkdir(file_path) unless File.directory?(file_path)
      File.open(file_path+now_hid.to_s, "w") { |file|
        file.write(params[:content])
      }

      # pstmt = @con.prepare "SELECT description, by_user_email FROM docs_histories WHERE id = ?"
      # pstmt.execute now_hid
      # col = pstmt.fetch
      # if col
      #   history_timestamp = col[0]
      #   history_email = col[1]
      # end

      pstmt = @con.prepare "SELECT filename FROM docs WHERE id = ?"
      pstmt.execute params[:doc_id]

      filename = pstmt.fetch[0]
      file_path = "#{Rails.root}/public/doc_data/"
      Dir.mkdir(file_path) unless File.directory?(file_path)
      File.open(file_path+filename, "w+") { |file|
        file.write(params[:content])
      }
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
      params.merge!(:history_id => now_hid, :history_timestamp => history_timestamp, :history_email => history_email)
      # params = ActionController::Parameters.new(params.merge(:history_id => now_hid.to_s))
      $redis.publish('new_message',params.to_json)
    end  
    
    render nothing: true
  end

  def addlist
    doc_id = params[:doc_id]
    begin
      db_init
      pstmt = @con.prepare "INSERT INTO docs_users (user_id, doc_id) VALUES (?, ?)"
      pstmt.execute cookies['id'], doc_id
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
      redirect_to('/docs/'+params[:doc_id].to_s)
    end
  end

  # GET /docs
  # GET /docs.json
  def index
    @doc_id = []
    @doc_title = []
    @doc_owner_name = []
    @doc_owner_email = []

    db_init
    begin
      pstmt = @con.prepare "SELECT username, login_email FROM users WHERE id = ?"
      pstmt.execute cookies['id']
      user_data = pstmt.fetch
      
      @my_name = user_data[0]
      @my_email = user_data[1]

      pstmt = @con.prepare "SELECT D.id, D.title, U.login_email, U.username FROM docs D JOIN docs_users L ON L.doc_id = D.id AND L.user_id = ? JOIN users U ON U.id = D.owner_user_id"
      ## pstmt = @con.prepare "SELECT D.id, D.title, D.owner_user_id FROM docs D JOIN docs_users L ON L.doc_id = D.id AND L.user_id = ?"

      # pstmt = @con.prepare "SELECT D.id D.title FROM docs D JOIN (SELECT doc_id FROM docs_users WHERE user_id = ?) List ON List.doc_id = D.id"
      # pstmt = @con.prepare "SELECT D.id, D.title, U.login_email, U.username FROM docs D, users U, (SELECT doc_id FROM docs_users WHERE user_id = ?) AS LIST_DOC WHERE LIST_DOC.doc_id = D.id AND D.owner_user_id = U.id"
      
      pstmt.execute cookies['id']
      # pstmt.size do
      pstmt.each do |id,title,own_email,own_name|
        @doc_id.push(id)
        @doc_title.push(title)
        @doc_owner_email.push(own_email)
        @doc_owner_name.push(own_name)
        ## pstmt = @con.prepare "SELECT login_email, username FROM users WHERE id = ?"
        ## pstmt.execute own_id
        ## userinfo = pstmt.fetch
        
        ## @doc_owner_email.push(userinfo[0])
        ## @doc_owner_name.push(userinfo[1])
      end
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
    end
  end

  # GET /docs/1
  # GET /docs/1.json
  def show
    db_init
    begin
      pstmt = @con.prepare "SELECT count(1) FROM docs_users WHERE user_id = ? AND doc_id = ?"
      pstmt.execute cookies['id'], @doc.id
      @count = pstmt.fetch[0]

      pstmt = @con.prepare "SELECT description, by_user_email FROM docs_histories WHERE id = ?"
      pstmt.execute @doc.now_history_id
      col = pstmt.fetch
      if col
        @history_timestamp = col[0]
        @history_email = col[1]
      end
      
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
    end
    file_path = "#{Rails.root}/public/doc_data/"
    if File.exist?(file_path+@doc.filename)
      file = File.open(file_path+@doc.filename, "r")
      data = file.read
      @fileload = data
    end
  end

  # GET /docs/new
  def new
    @doc = Doc.new
  end

  # GET /docs/1/edit
  def edit
  end

  # POST /docs
  # POST /docs.json
  def create
    begin
      db_init
      filename = @my_name.hash.to_i.abs.to_s + Time.now.to_i.to_s

      pstmt = @con.prepare "INSERT INTO docs (title, owner_user_id, filename) VALUES (?, ?, ?)"
      pstmt.execute params[:doc][:title], cookies['id'], filename

      pstmt = @con.prepare "INSERT INTO docs_users (user_id, doc_id) VALUES (?, (SELECT id FROM docs WHERE filename = ?))"
      pstmt.execute cookies['id'], filename

    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
      redirect_to('/docs')
    end
    # @doc = Doc.new(doc_params.merge(:owner_user_id => cookies['id']))

    # respond_to do |format|
    #   if @doc.save
    #     format.html { redirect_to @doc, notice: 'Doc was successfully created.' }
    #     format.json { render :show, status: :created, location: @doc }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @doc.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /docs/1
  # PATCH/PUT /docs/1.json
  def update
    respond_to do |format|
      if @doc.update(doc_params)
        format.html { redirect_to @doc, notice: 'Doc was successfully updated.' }
        format.json { render :show, status: :ok, location: @doc }
      else
        format.html { render :edit }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docs/1
  # DELETE /docs/1.json
  def destroy
    db_init
    begin
      pstmt = @con.prepare "DELETE FROM docs_users WHERE user_id = ? AND doc_id = ?"
      pstmt.execute cookies['id'], @doc.id
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
    end
    respond_to do |format|
      format.html { redirect_to docs_url, notice: '내 리스트에서 문서 삭제됨' }
      format.json { head :no_content }
    end
  end

  def kill
    db_init
    begin
      pstmt = @con.prepare "DELETE FROM docs WHERE id = ?"
      pstmt.execute params[:id]

      pstmt = @con.prepare "DELETE FROM docs_users WHERE doc_id = ?"
      pstmt.execute params[:id]

      pstmt = @con.prepare "DELETE FROM docs_histories WHERE docs_id = ?"
      pstmt.execute params[:id]
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
    end
    respond_to do |format|
      format.html { redirect_to docs_url, notice: 'Doc was completely destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc
      @doc = Doc.find(params[:id])
    end

    # def set_id
    #   db_init
    #   begin
    #     pstmt = @con.prepare "SELECT id FROM docs WHERE id = ?"
    #     pstmt.execute @doc.id

    #     pstmt = @con.prepare "DELETE FROM docs_users WHERE docs_id = ?"
    #     pstmt.execute @doc.id
    #   rescue Mysql::Error => e
    #     puts e.errno
    #     puts e.error
    #   ensure
    #     @con.close if @con
    #   end
    #   respond_to do |format|
    #     format.html { redirect_to docs_url, notice: 'Doc was completely destroyed.' }
    #     format.json { head :no_content }
    #   end
    #   @doc = Doc.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_params
      params.require(:doc).permit(:title, :filename, :now_history_id, :owner_user_id)
    end
end
