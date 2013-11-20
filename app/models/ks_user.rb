class KsUser < ActiveRecord::Base
  has_many :ks_project_backers
  has_many :ks_projects, :through => :ks_project_backers

  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]

  attr_reader :max_category
  attr_accessor :category_counts

  def score_sum # for validating the data
    art_score + comics_score + dance_score + design_score + fashion_score + film_score + food_score + games_score + music_score + photography_score + publishing_score + technology_score + theater_score
  end

  def mode(array)
    count = Hash.new(0)
    array.each {|x| count[x] += 1 }
    count.sort_by{|k,v| v}.last[0]
  end

  def set_category_counts
    projects = Hash.new(0)
    self.ks_projects.each do |project|
      begin
        projects[project.parent_category.downcase.split.first] += 1
      rescue
      end
    end
    @category_counts = projects
  end

  def max_category
    self.category_counts.sort_by {|k,v| v}.last[0]
  end

  def max_count
    category_counts[max_category]
  end

  def set_category_scores
    CATEGORIES.each do |category|
      if max_category == category 
        self.send("#{category}_score=",100)
      else
        self.send("#{category}_score=",100*category_counts[category]/max_count)
      end
    end
    self.save
  end

  def set_art_score
    if max_category == "art"
      art_score = 100
    else
      art_score = 100*category_counts["art"]/max_count
    end
  end

  def self.aggregate_points_from_table_data(number)
    users = self.where("id < #{number}")
    user_point_arrays = users.collect do |user|
      user.points_from_table_data
    end
  end

  def points_from_table_data
    points = CATEGORIES.collect do |category|
      self.send("#{category}_score")
    end
  end

end
