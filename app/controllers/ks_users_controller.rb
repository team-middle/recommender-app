class KsUsersController < ApplicationController

  def index
    @ks_users100 = KsUser.where("id < 100")
    @ks_users100.each do |user| 
      user.set_category_counts
      user.set_category_scores
    end
  end


end
