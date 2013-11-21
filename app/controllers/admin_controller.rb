class AdminController < ApplicationController
  def index
  end

  def reset
   #@user = User.find_by(:username => "Joe")
   #@point = @user.user_data_as_coordinate
    Center.destroy_all
    @clusters = Kmeans.new
    ks_points = KsUser.aggregate_points_from_table_data(params[:user_count].to_i)
    @clusters_hash = @clusters.cluster(params[:k].to_i,ks_points,params[:max_iterations].to_i)
    @centers = @clusters_hash.keys

    #!!!!!!!add centers to database !!!!!!!!!
    Center.add_centers(@centers)
    KsUser.add_centers(@clusters_hash)
  # @distances = @centers.collect do |center|
  #   @clusters.distance(center,@point)
  # end
  # @recs_users = @clusters_hash.collect do |center, ks_users|
  #   ks_users.sample
  # end

  #  @ks_users = @recs_users.collect do |user_point|
  #    KsUser.find_by(:art_score => user_point[0], :comics_score => user_point[1], :dance_score => user_point[2], :design_score => user_point[3], :fashion_score => user_point[4], :film_score => user_point[5], :food_score => user_point[6], :games_score => user_point[7], :music_score => user_point[8], :photography_score => user_point[9], :publishing_score => user_point[10], :technology_score => user_point[11], :theater_score => user_point[12]) 
  #  end
  # 
  #  @ks_urls = @ks_users.collect do |user|
  #    user.url
  #  end

  #  @rec_projects = @ks_users.collect do |user|
  #    user.ks_projects.sample.url
  #    # obviously this pulls up expired projects
  #  end

  #  @recs = @recs_users.zip(@distances, @ks_urls, @rec_projects)
    redirect_to :results, :notice => "Centers were calculated"
  end

  def results
    @centers = Center.all
  end


end
