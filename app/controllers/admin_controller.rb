class AdminController < ApplicationController
  def index
  end

  def reset

    Center.destroy_all
    @clusters = Kmeans.new
    ks_points = KsUser.aggregate_points_from_table_data(params[:user_count].to_i)
    @clusters_hash = @clusters.cluster(params[:k].to_i,ks_points,params[:max_iterations].to_i)
    @centers = @clusters_hash.keys

    #!!!!!!!add centers to database !!!!!!!!!
    Center.add_centers(@centers)
    # add centers to ks_users
    KsUser.add_centers(@clusters_hash)

    redirect_to :results, :notice => "Centers were calculated"
  end

  def set_centers

  end

  def results
    @centers = Center.all
    @sample_user = KsUser.find(20)
    
  end


end
