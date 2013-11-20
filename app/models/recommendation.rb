class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :ks_project
end
