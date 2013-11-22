class RecommendationsController < ApplicationController

before_action :set_user_from_session, :only => [:index, :create]

  def index

  end

  def create
    @user.assign_center # need to write this method
    ks_users_in_cluster = KsUser.where(:center => @user.center)
    @neighbor = ks_users_in_cluster.sample

    @project = @neighbor.ks_projects.sample

    @rec = Recommendation.new(:user => @user, :ks_project => @project)
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
