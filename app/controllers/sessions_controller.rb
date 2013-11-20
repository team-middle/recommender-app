class SessionsController < ApplicationController

  def index

  end

  def login
    session[:oauth] = Koala::Facebook::OAuth.new('1479578555600942', 'fc183993624d812466f13a571bf3df0c', 'http://localhost:3000/sessions/show')
    @auth_url = session[:oauth].url_for_oauth_code(:permissions => "read_stream publish_stream")
    redirect_to @auth_url

  end

  def show
    if params[:code]
      session[:access_token] = session[:oauth].get_access_token(params[:code])
    end

    @api = Koala::Facebook::API.new(session[:access_token])

    begin 
      @user_profile = @api.get_object('me')
    rescue
      redirect_to '/sessions', notice: "error" and return
    end
  
    @friends = @api.get_connection(@user_profile["id"], "friends")
    @facebook_cookies = session[:oauth].get_user_info_from_cookies(cookies)
    # @graph = Koala::Facebook::GraphAPI.new(@facebook_cookies["access_token"])
    @likes = @api.get_connections("me","likes")
    render :page
  end

  def logout
    session.clear
    params.clear
    redirect_to sessions_path, notice: "logged out"
  end



end
