class KsProjectBacker < ActiveRecord::Base
  belongs_to :ks_user
  belongs_to :ks_project

end
