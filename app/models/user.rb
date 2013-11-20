class User < ActiveRecord::Base
  has_many :recommendations
  
  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]

  attr_reader :counts

    def user_data_as_coordinate
      array = (1..13).collect do |i|
        category = CATEGORIES[i-1]
        self.send("#{category}_score")
      end
    end

    def create_scores(likes)
      fb_categories = extract_category(likes)
      ks_categories = convert_categories(fb_categories)
      @counts = count_categories(ks_categories)
      scores = set_category_scores
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
      @counts = Hash.new(0)
      CATEGORIES.each do |category|
        @counts[category] = array.count(category)
      end
      @counts
    end

    def set_category_scores
      CATEGORIES.each do |category|
        if max_category == category 
          self.send("#{category}_score=",100)
        else
          self.send("#{category}_score=",100*counts[category]/max_count)
        end
      end
      self.save
    end


    def max_category
      counts.sort_by {|k,v| v}.last[0]
    end

    def max_count
      counts[max_category]
    end

    def scores
      CATEGORIES.collect do |category|
        self.send("#{category}_score")
      end
    end

end
