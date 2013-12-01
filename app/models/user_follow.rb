class UserFollow < ActiveRecord::Base
  belongs_to :user 
  belongs_to :ks_user
  
end
