class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # POST /users
  # POST /users.json
  def create
    session[:access_token] = FacebookOAuth.get_access_token(params[:code])

    api = Koala::Facebook::API.new(session[:access_token])
    user_profile = api.get_object('me')
    session[:username] = user_profile["username"]
    likes = api.get_connections("me","likes")
    
    @user = User.find_or_create_by(:username => session[:username])

    if @user.scores
    else   
      @user.create_scores(likes) # will populate the 13 dimensions
    end


    if @user.save
      # render :"recommendations/index"
      redirect_to recommendations_path
    else
      render :index, notice: "error"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def logged_in?
      session[:access_token]
    end

    def set_user_from_session
      @user = User.find_by(:username => session[:username])
    end

end
