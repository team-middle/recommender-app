class KsUsersController < ApplicationController

  def index
    @ks_users10 = KsUser.limit(10)
    @ks_users10.each do |user| 
      user.set_categories_count
      user.set_category_scores
    end
  end


end
