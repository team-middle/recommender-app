class RecommendationsController < ApplicationController

before_action :set_user_from_session, :only => [:index, :create]

  def index

  end

  def create
    @user.assign_center
    ks_users_in_cluster = KsUser.where(:center => @user.center).shuffle

    @most_similar = ks_users_in_cluster.min_by do |user|
      Kmeans.distance(@user.scores, user.scores)
    end
    
    if @most_similar.image_url.include?("http")
      @most_similar_image_url = @most_similar.image_url
    else 
      @most_similar_image_url = "http://www.kickstarter.com" + @most_similar.image_url
    end

    # there are many users who share the exact same score footprint -- it makes sense to find all of them when looking for active projects
    @ranked_active_projects = Hash.new(0)
    ks_users_in_cluster.each do |user|
      actives = user.ks_projects.where(:active => true)
      actives.each do |project|
        @ranked_active_projects[project] += 1
      end
    end

    @ranked_active_projects.keys.each do |project|
      Recommendation.find_or_create_by(:user => @user, :ks_project => project)
    end

    @array = @ranked_active_projects.sort_by { |k,v| v }.reverse

    @active_recs = Recommendation.where(:user => @user, :useful => nil)

    @random = KsProject.random_active

    # TODO: implement with AJAX
    render :index
  end

  private

    def set_user_from_session
      @user = User.find_by(:username => session[:username])
    end

    def set_user_from_api
     @api = Koala::Facebook::API.new(session[:access_token])
      username = @api.get_object('me')["username"]
      @user = User.find_by(:username => username)
    end

end
