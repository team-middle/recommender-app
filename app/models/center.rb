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

  def self.find_by_scores(array)
    self.find_by(:art_score => array[0], :comics_score => array[1], :dance_score => array[2], :design_score => array[3], :fashion_score => array[4], :film_score => array[5], :food_score => array[6], :games_score => array[7], :music_score => array[8], :photography_score => array[9], :publishing_score => array[10], :technology_score => array[11], :theater_score => array[12])
  end


end
