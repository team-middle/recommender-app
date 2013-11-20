class Center < ActiveRecord::Base
  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]
  has_many :ks_users
  def self.add_centers(centers)
    centers.each do |center|
      c = Center.new
      CATEGORIES.each_with_index do |category, i|
        c.send("#{category}_score=", center[i])
      end
      c.save
    end
  end
end
