class KsProjectBacker < ActiveRecord::Base
  belongs_to :ks_user
  belongs_to :ks_project

  # def self.find_duplicates(scope)
  #   # TODO: write this method; duplicates exist
  # With :dependent => :destroy, when duplicate users or duplicate projects are destroyed, the KsProjectBacker records associated with that user or project are also destroyed, so maybe I don't need to search for duplicates
  #   dups = []
  #   self.where("id < #{scope}").each do |first|

  #     # for each record, go through all the other records to see if ks_user_id from first matches ks_user_id from second AND ks_project_id from first matches ks_project_id from second
  #     # exclude matches where the second record id is the same as the first record id



end
