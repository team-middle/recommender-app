class KsUser < ActiveRecord::Base
  has_many :ks_project_backers
  has_many :ks_projects, :through => :ks_project_backers

  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "tech", "theater"]

  attr_reader :max_category
  attr_accessor :categories_count

  def mode(array)
    count = Hash.new(0)
    array.each {|x| count[x] += 1 }
    count.sort_by{|k,v| v}.last[0]
  end

  def set_categories_count
    projects = Hash.new(0)
    self.ks_projects.each do |project|
      projects[project.parent_category.downcase] += 1
    end
    @categories_count = projects
  end

  def max_category
    self.categories_count.sort_by {|k,v| v}.last[0]
  end

  def max_count
    categories_count[max_category]
  end

  def set_category_scores
    CATEGORIES.each do |category|
      if max_category == category 
        self.send("#{category}_score=",100)
      else
        self.send("#{category}_score=",100*categories_count[category]/max_count)
      end
    end
  end

  def set_art_score
    if max_category == "art"
      art_score = 100
    else
      art_score = 100*categories_count["art"]/max_count
    end
  end

  # def set_comics_score

  # end

  # def set_dance_score

  # end

  # def set_fashion_score

  # end

  # def set_film_score

  # end

  # def set_food_score

  # end

  # def set_games_score 

  # end

  # def set_music_score

  # end

  # def set_photography_score

  # end

  # def set_publishing_score

  # end

  # def set_tech_score

  # end






end
