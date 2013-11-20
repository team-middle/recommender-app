class User < ActiveRecord::Base
  has_many :recommendations
  
  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]

    def user_data_as_coordinate
      array = (1..13).collect do |i|
        category = CATEGORIES[i-1]
        self.send("#{category}_score")
      end
    end

    def create_scores(likes)
      fb_categories = extract_category(likes)
      ks_categories = convert_categories(fb_categories)
      counts = count_categories(ks_categories)
      # scores = set_category_scores
      raise
    end

    def extract_category(likes)
      likes.collect do |like|
        like["category"]
      end
    end

    def convert_categories(fb_array)
      fb_array.map do |category|
        Dictionary::CATEGORY_DICTIONARY[category.downcase.to_sym]
      end
    end

    def count_categories(array)
      CATEGORIES.collect do |category|
        array.count(category)
      end
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

    def convert_to_score(counts)

    end


end
