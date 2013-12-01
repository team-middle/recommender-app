class KsUser < ActiveRecord::Base
  has_many :ks_project_backers, :dependent => :destroy
  has_many :ks_projects, -> { uniq }, :through => :ks_project_backers
  has_many :user_follows, :dependent => :destroy
  has_many :users, :through => :user_follows
  belongs_to :center

  # to rescore the users:
    # select your sample with KsUser.where("id < #{sample}")
    # set category counts and scores for each user
      # eg
      # users.each { |u| u.set_category_counts; u.set_category_scores }
    # (optionally, select prolific backers and/or detect and delete duplicate users)
    # run KsUser.aggregate_points_from_table_data
    # plug points into Kmeans.new.cluster
    # add new centers to database with Center.add_centers(clusters_hash.keys)
    # add centers by adding KsUser.add_centers(clusters_hash)

  CATEGORIES = ["art", "comics", "dance", "design", "fashion", "film", "food", "games", "music", "photography", "publishing", "technology", "theater"]

  attr_reader :max_category
  attr_accessor :category_counts

  def self.add_centers(clusters_hash)
    clusters_hash.each do |center_point, users_points|
      center = Center.find_by_scores(center_point)
      users_points.each do |user_point|
        user = KsUser.find_by_scores(user_point)
        user.center = center
        user.save
      end
    end
  end

  def self.find_by_scores(array)
    self.find_by(:art_score => array[0], :comics_score => array[1], :dance_score => array[2], :design_score => array[3], :fashion_score => array[4], :film_score => array[5], :food_score => array[6], :games_score => array[7], :music_score => array[8], :photography_score => array[9], :publishing_score => array[10], :technology_score => array[11], :theater_score => array[12])
  end

  def date_joined
    if self.joined
      date = self.joined.split[0]
      time_args = date.split("-")
      joined_time = Time.new(*time_args).strftime('%B %e, %Y')
    end
  end


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

  def self.select_prolific_backers(sample_size, project_min)
    ks_users = KsUser.where("id < #{sample_size}")
    # TODO: is this the best way to do this? can we do it in SQL?
    ks_users.select do |user|
      user.ks_projects.count >= project_min
    end
  end

  def scores
    CATEGORIES.collect do |category|
      self.send("#{category}_score")
    end
  end


  def points_from_table_data
    points = CATEGORIES.collect do |category|
      self.send("#{category}_score")
    end
  end

  def self.scrape(users)
    users.each do |user|
      if user.scraped
        puts "already scraped #{user.url}, #{user.id}"
        next
      else
        url = user.url
        user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))

        # coffee.css(".NS_backers__backing_row").last.css("a").attr("href").value
        user = KsUser.find_or_create_by(:url => url)

        urls_for_backed_projects = user_page.css("a.project_item").collect do |project|
          project_url = project.attr('href')
          ks_project = KsProject.find_or_create_by(:url => project_url)
          user.ks_project_backers.find_or_create_by(:ks_project => ks_project)
          puts "scraped #{ks_project.url}"
        end
        user.update(:scraped => true)
        user.save
        puts "    finished scraping #{user.url}, #{user.id}"
      end
    end
  end

  def self.scrape_vitals(range)
    users = KsUser.where(:id => range)
    
    users.each do |user|
      url = user.url
      user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))
      user.image_url = user_page.xpath("//meta[@property='og:image']/@content").text
      user.name = user_page.xpath("//meta[@property='kickstarter:name']/@content").text
      user.joined = user_page.xpath("//meta[@property='kickstarter:joined']/@content").text
      user.description = user_page.xpath("//meta[@property='og:description']/@content").text
      user.location = user_page.css("span.location").text
      user.save
    end
  end

  def self.scrape_bio(range)
    users = KsUser.where(:id => range)
    
    users.each do |user|
      bio_url = "http://www.kickstarter.com/profiles/" + user.url.split("/").last + "/bio"

      bio_page = Nokogiri::HTML(open(bio_url))
      user.bio = bio_page.css("div#profile-bio-full p").text
      user.save
    end
  end


  def self.find_duplicates(range)
    users = KsUser.where(:id => range)
    users.select do |user|
      KsUser.where(:url => user.url).size > 1
    end
  end

  def clean_duplicates(dups)
    # find all of the ks_user_ids for a given url
    # collect all of the projects that they have backed in total
    # check each project to see if a ks_project_backer relation has been created for the original user
    # if not, create the record
    # if so, move on
    
    dups.each do |duplicate|
      group_of_same = KsUser.where(:url => duplicate.url)
      orig = group_of_same.min_by { |u| u.id }

      backed_projects = group_of_same.collect do |clone|
        clone.ks_projects
      end.flatten.uniq

      backed_projects.each do |project|
        orig.ks_projects.find_or_create_by(:url => project.url)
      end
      orig.save

      group_of_same.reject! { |u| u.id == orig.id }
      group_of_same.each do |clone|
        clone.destroy
      end
    end

  end

end
