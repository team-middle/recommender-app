class User < ActiveRecord::Base
  has_many :recommendations
  has_many :user_follows, :dependent => :destroy
  has_many :ks_users, :through => :user_follows
  belongs_to :center
  
  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]

  attr_reader :counts

  # def self.from_omniauth(auth)
  #   raise
  #   where(auth.slice(:provider, :username)).find_or_create_by(:username => session[:username])
  # end


    def user_data_as_coordinate
      array = (1..13).collect do |i|
        category = CATEGORIES[i-1]
        self.send("#{category}_score")
      end
    end

    def adjust_score(category, feedback)
    # will get a POST to adjust_score action
    # params will have the project category and the like/dislike
    # the user's score for that column will be adjusted by 10, up to a maximum of 100 and minimum of 0

      old_score = self.send("#{category}_score")
      feedback == "true" ? new_score = old_score + 10 : new_score = old_score - 10
      new_score = 100 if new_score > 100
      new_score = 0 if new_score < 0
      self.update("#{category}_score" => new_score)
      self.save
    end


    def create_scores(likes)
      fb_categories = extract_category(likes)
      ks_categories = convert_categories(fb_categories)
      @counts = count_categories(ks_categories)
      scores = set_category_scores
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

    def assign_center
      centers = Center.all
      distances = Hash.new 
      centers.each do |center|
        distances[center] = Kmeans.distance(center.scores, self.scores)
      end
      self.center = distances.sort_by {|center, distance| distance}.first[0]
      self.save
    end

end
