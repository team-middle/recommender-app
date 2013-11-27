class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def adjust_score
    set_user_from_session
    # will get a POST to adjust_score action
    # params will have the project category and the like/dislike
    # the user's score for that column will be adjusted by 10, up to a maximum of 100 and minimum of 0
    @user.adjust_score(params[:category].split.first.downcase, params[:feedback])
    @user.assign_center
    message = { message: 'first-column' }
    render :json => message
    # redirect_to recommendations_path
  end
  
  def create
    # session[:access_token] = FacebookOAuth.get_access_token(params[:code])
    api = Koala::Facebook::API.new(session[:access_token])
    user_profile = api.get_object('me')
    session[:username] = user_profile["username"]
    likes = api.get_connections("me","likes")
    
    @user = User.find_or_create_by(:username => session[:username])

    if @user.scores.first.nil?
      @user.create_scores(likes) # will populate the 13 dimensions
    else   
    end

    redirect_to recommendations_path
    # if @user.save
    #   # render :"recommendations/index"
    # else
    #   render :index, notice: "error"
    # end
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
