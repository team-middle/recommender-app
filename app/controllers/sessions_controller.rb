class SessionsController < ApplicationController

  def index
    @user = current_user
  end

  def create

    auth_hash = request.env['omniauth.auth']
    session[:username] = auth_hash['extra']['raw_info']['username']
    session[:access_token] = auth_hash['credentials']['token']
    present = User.find_by(:username => session[:username])
    if present
      notice = "welcome back, #{session[:username]}"
    else
      user = User.new(:username => session[:username])
      user.save
      notice = "thanks for using Kickamender, #{session[:username]}"
    end

    redirect_to create_user_path
  end

  def destroy
    session.clear
    redirect_to '/', notice: "logged out"
  end

end
