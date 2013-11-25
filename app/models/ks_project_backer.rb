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

  #     self.where("id < #{scope}").each do |second| 
  #       if first.ks_user_id == second.ks_user_id
  #         if first.ks_project_id == second.ks_project_id
  #           if first.id != second.id 
  #              dups << second
  #           else
  #             next
  #           end
  #         else
  #           next
  #         end
  #       else
  #         next
  #       end
  #     end
  #   end
  #   dups
  # end

  # def self.find_duplicates
  #   dups = []
  #   5000.times do |i|
  #     KsProject.all.size.times do |j|
  #       assoc = KsProjectBacker.where(:ks_user_id => i, :ks_project_id => j)
  #       if assoc.size > 1
  #         dups << assoc
  #       end
  #     end
  #   end
  #   dups
  # end



end
