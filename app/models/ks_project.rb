class KsProject < ActiveRecord::Base
  has_many :ks_project_backers
  has_many :ks_users, :through => :ks_project_backers
  has_many :recommendations

end
