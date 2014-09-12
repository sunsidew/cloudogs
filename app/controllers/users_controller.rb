class UsersController < ApplicationController
  def db_init
    config = Rails.configuration.database_configuration
    servername = config[Rails.env]["host"]
    dbname = config[Rails.env]["database"]
    serveruser = config[Rails.env]["username"]
    serverpw = config[Rails.env]["password"]

    @con = Mysql.new servername, serveruser, serverpw, dbname
  end

  def login
    email = params[:email]
    password = params[:password]
    
    if cookies['membership'] != "user"
      begin
        db_init()
        pstmt = @con.prepare "SET @result = NULL"
        pstmt.execute

        puts "pw:#{password}"
        pstmt = @con.prepare "call login(?, ?, @result)"
        pstmt.execute email, password
        #pstmt.close
        @con.reconnect
        pstmt = @con.prepare "select @result"
        pstmt.execute
        login_result = pstmt.fetch[0]
        puts "res:#{login_result}"

        if login_result == "PASS"
          pstmt = @con.prepare "select id from users where login_email = ?"
          pstmt.execute email
          cookies[:membership] = { :value => "user", :expires => 1.hour.from_now }
          cookies[:id] = {:value => pstmt.fetch[0], :expires => 1.hour.from_now }
          success_to
        else
          failed_to
        end
      rescue Mysql::Error => e
        puts e.errno
        puts e.error
      ensure
        @con.close if @con
      end
    else
      success_to
    end
  end

  def signup
    email = params[:email]
    password = params[:password]
    username = params[:username]
    begin
      db_init()
      pstmt = @con.prepare "SET @result = NULL;"
      pstmt.execute

      pstmt = @con.prepare "call signup(?, ?, ?, @result)"
      pstmt.execute email, password, username

      pstmt = @con.prepare "select @result"
      pstmt.execute

      if pstmt.fetch[0] == "PASS"
        redirect_to('/')
      else
        redirect_to('/create')
      end
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      @con.close if @con
    end
  end

  def logout
    # delete cookie
    cookies.delete :membership
    cookies.delete :id
    failed_to
  end
  
  def success_to
    redirect_to('/docs')
  end
  
  def failed_to
    redirect_to('/')
  end
  
  private :success_to, :failed_to

  # before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
  end
end
