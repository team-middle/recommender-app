class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def adjust_score
    set_user_from_session
    # will get a POST to adjust_score action
    # params will have the project category and the like/dislike
    # the user's score for that column will be adjusted by 10, up to a maximum of 100 and minimum of 0
    @user.adjust_score(params[:category].split.first.downcase, params[:feedback])
    @user.assign_center
    redirect_to recommendations_path
  end

  def recommend

    render :recommend
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @users = User.all
    @clusters = Kmeans.new
    points = []
    @users.each do |user|
      points << [user.c1,user.c2,user.c3,user.c4,user.c5,user.c6,user.c7,user.c8,user.c9,user.c10,user.c11,user.c12,user.c13]
    end
    #points = [[4,2,1,3],[4,3,2,2],[4,4,3,1],[1,2,4,4],[1,3,4,0],[1,1,0,0],[3,2,1,2],[3,4,2,1],[4,4,3,2],[0,0,4,4],[0,1,2,0]]
    @clusters = @clusters.cluster(1,points,10)
    center = []
    @clusters.each do |k,v|
      if v.include?([@user.c1,@user.c2,@user.c3,@user.c4,@user.c5,@user.c6,@user.c7,@user.c8,@user.c9,@user.c10,@user.c11,@user.c12,@user.c13])
        center << k
      end
    end
    same_clustered_users = @clusters[center.first].map do |p|
   #same_clustered_users = @clusters[center].map do |p|
      User.find_by(c1: p[0], c2: p[1], c3: p[2], c4: p[3], c5: p[4], c6: p[5], c7: p[6], c8: p[7], c9: p[8], c10: p[9], c11: p[10], c12: p[11], c13: p[12])
    end

    s = same_clustered_users.compact.reject{|x| x.id.to_s  == params[:id]}
    @recommend = s.map{|x| x.username}
  # in_same_cluster = User.find(params[:id])
  
  end

  # sandbox action; serves no purpose in production


  def test
    @user = User.find_by(:username => "Joe")
    @point = @user.user_data_as_coordinate
    @clusters = Kmeans.new
    ks_points = KsUser.aggregate_points_from_table_data(1000)
    @clusters_hash = @clusters.cluster(10,ks_points,16)
    @centers = @clusters_hash.keys
    @distances = @centers.collect do |center|
      @clusters.distance(center,@point)
    end

    @recs_users = @clusters_hash.collect do |center, ks_users|
      ks_users.sample
    end

    @ks_users = @recs_users.collect do |user_point|
      KsUser.find_by(:art_score => user_point[0], :comics_score => user_point[1], :dance_score => user_point[2], :design_score => user_point[3], :fashion_score => user_point[4], :film_score => user_point[5], :food_score => user_point[6], :games_score => user_point[7], :music_score => user_point[8], :photography_score => user_point[9], :publishing_score => user_point[10], :technology_score => user_point[11], :theater_score => user_point[12]) 
    end
   
    @ks_urls = @ks_users.collect do |user|
      user.url
    end

    @rec_projects = @ks_users.collect do |user|
      user.ks_projects.sample.url
      # obviously this pulls up expired projects
    end

    @recs = @recs_users.zip(@distances, @ks_urls, @rec_projects)

    render :test
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    session[:access_token] = session[:oauth].get_access_token(params[:code])

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
      render :"recommendations/index"
      #redirect_to recommendations_path
    else
      render :index, notice: "error"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def logged_in?
      session[:oauth]
    end

    def set_user_from_session
      @user = User.find_by(:username => session[:username])
    end

    # def set_user
    #   @user = User.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def user_params
    #   params.require(:user).permit(:username, :c1, :c2, :c3 , :c4 , :c5 , :c6 , :c7 , :c8 , :c9 , :c10 , :c11 , :c12 , :c13)
    # end
end
