class KsUser < ActiveRecord::Base
has_many :ks_project_backers
has_many :ks_projects, :through => :ks_project_backers

end
