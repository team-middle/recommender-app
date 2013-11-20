class KsUsersController < ApplicationController

  def index
    @ks_users1000 = KsUser.where("id < 1000")
    @ks_users1000.each do |user| 
      user.set_category_counts
      user.set_category_scores
    end
  end


end
