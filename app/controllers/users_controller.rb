class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_user_from_session, only: [:adjust_score, :follow, :show, :delete_saved]

  def adjust_score
    set_user_from_session
    rated_project = KsProject.find_by(:url => params[:url])
    recommendation = Recommendation.find_or_create_by(:user => @user, :ks_project => rated_project)
    recommendation.update(:useful => params[:feedback])

    # will get a POST to adjust_score action
    # params will have the project category and the like/dislike
    # the user's score for that column will be adjusted by 10, up to a maximum of 100 and minimum of 0
    @user.adjust_score(rated_project.parent_category.split.first.downcase, params[:feedback])
    @user.assign_center
    message = { message: 'first-column' }
    render :json => message
  end

  def delete_saved
    rec = @user.recommendations.find(params[:rec_id])
    rec.update(:useful => nil)

    render :json => "success"
  end
  
  def follow
    @user.user_follows.find_or_create_by(:ks_user_id => params[:most_similar_id])    
    redirect_to user_path(@user)
  end

  def create
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
  end

  def show
    @recommendations = Recommendation.where(:user => @user)
    @liked_recs = @recommendations.where(:useful => true)
    @categories = Recommendation.display_categories(@liked_recs)
    follows = @user.user_follows
    @followed_users = follows.collect do |follow|
      follow.ks_user
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
