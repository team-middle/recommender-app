class RecommendationsController < ApplicationController

before_action :set_user_from_session, :only => [:index, :create]

  def index

  end

  def create
    @user.assign_center
    ks_users_in_cluster = KsUser.where(:center => @user.center).shuffle

    # begin    
    #   @neighbor = ks_users_in_cluster.sample
    #   @active_projects = @neighbor.ks_projects.select { |p| p.still_active? }
    # end while @active_projects.empty?

    @ranked_active_projects = Hash.new(0)
    ks_users_in_cluster.each do |user|
      actives = user.ks_projects.select { |p| p.still_active? }
      actives.each do |project|
        @ranked_active_projects[project] += 1
      end
    end

    @ranked_active_projects.keys.each do |project|
      Recommendation.find_or_create_by(:user => @user, :ks_project => project)
    end
    @array = @ranked_active_projects.sort_by { |k,v| v }.reverse



    # @project = @ranked_active_projects.sample
    # @rec = Recommendation.new(:user => @user, :ks_project => @project)

    # find a ks_user in the database with the same center as @user
    # find a project that ks_user has backed, and set that project -- rec.ks_project = project

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
