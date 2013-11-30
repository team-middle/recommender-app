class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :ks_project

  def self.display_categories(rec_array)
    rec_array.collect do |rec|
      rec.ks_project.parent_category.split.first.downcase
    end.uniq
  end

end
