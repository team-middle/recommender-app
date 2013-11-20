class KsUsersController < ApplicationController

  def index
    @ks_users200 = KsUser.where("id < 200")
    @ks_users200.each do |user| 
      user.set_category_counts
      user.set_category_scores
    end
  end


end
