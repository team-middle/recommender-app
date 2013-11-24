class SessionsController < ApplicationController

  def index

  end

  def create
    auth_hash = request.env['omniauth.auth']
    session[:username] = auth_hash['extra']['raw_info']['username']
    present = User.find_by(:username => session[:username])
    if present
      notice = "welcome, back #{session[:username]}"
    else
      user = User.new(:username => session[:username])
      user.save
      notice = "thanks for using Kickamender, #{session[:username]}"
    end

    redirect_to recommendations_path, notice: notice
  end
  # def create
  #   raise
  #   user = User.from_omniauth(env["omniauth.auth"])
  #   session[:username] = user.username
  #   redirect_to root_url

  # end


  def destroy
    session.clear

    redirect_to root_url, notice: "logged out"
  end


  def show
    if params[:code]
      session[:access_token] = FacebookOAuth.get_access_token(params[:code])
    end

    @api = Koala::Facebook::API.new(session[:access_token])

    begin 
      @user_profile = @api.get_object('me')
    rescue
      redirect_to '/sessions', notice: "error" and return
    end
  
    @friends = @api.get_connection(@user_profile["id"], "friends")
    @facebook_cookies = FacebookOAuth.get_user_info_from_cookies(cookies)
    # @graph = Koala::Facebook::GraphAPI.new(@facebook_cookies["access_token"])
    @likes = @api.get_connections("me","likes")

    #render :page
    session[:username] = @user_profile["username"]

    @user = User.find_or_create_by(:username => session[:username])
    @user.create_scores(@likes)
    render :"recommendations/index"

  end




end
