class KsProject < ActiveRecord::Base
  has_many :ks_project_backers, :dependent => :destroy
  has_many :ks_users, -> { uniq }, :through => :ks_project_backers
  has_many :recommendations


  def still_active?
    begin
    date_array = self.end_date.split
    hour_min_array = date_array[4].split(/:/)
    hour = hour_min_array[0]
    min = hour_min_array[1]
    utc = date_array[5].split(//).insert(3, ":").join
    end_time = Time.new(date_array[3], date_array[2], date_array[1], hour, min, 0)

    end_time > Time.now
    rescue
      puts "error"
    end
  end

  def self.random_active
    KsProject.where(:active => true).sample
  end

  def ending_soon?

  end

  def add_user(user)
      self.ks_project_backers.find_or_create_by(:ks_user => user)
      self.save
  end

  def self.scrape_without_users(projects)
    projects.each do |project|
      if project.scraped
        puts "already scraped #{project.url}"
        next
      else
        project_backers_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{project.url}/backers"))
        project.title = project_backers_page.xpath("//meta[@property='og:title']/@content").text
        project.creator_id = project_backers_page.xpath("//meta[@property='kickstarter:creator']/@content").text.split(/\//).last
        project.description = project_backers_page.xpath("//meta[@property='og:description']/@content").text
        project.parent_category = project_backers_page.xpath("//li['@class=category']/@data-project-parent-category").text
        project.category = project_backers_page.css("div.NS-project_-running_board li.category").text.strip
        project.funding_goal = project_backers_page.xpath("//div['@id=pledged']/@data-goal").text.to_i
        project.pledged = project_backers_page.xpath("//div['@id=pledged']/@data-pledged").text.to_i
        project.latitude = project_backers_page.xpath("//meta[@property='kickstarter:location:latitude']/@content").text
        project.longitude = project_backers_page.xpath("//meta[@property='kickstarter:location:longitude']/@content").text
        project.end_date = project_backers_page.xpath("//h5 ['@class=poll']/@data-end_time").text
        project.updates_count = project_backers_page.xpath("//span['@id=updates_count']/@data-updates-count").text.to_i
        project.comments_count = project_backers_page.xpath("//span['@id=comments_count']/@data-comments-count").text.to_i
        project.backer_count = project_backers_page.xpath("//data['@itemprop=Project[backers_count]']/@data-value").first.value.to_i
        project.image_url = project_backers_page.xpath("//meta[@property='og:image']/@content").text
      end

      if project.save
        project.scraped = true 
        project.save 
      else
        puts "there was an error"
      end
    puts "   finished scraping #{project.title}, #{project.id}"
    end
  end

  def self.scrape_video(projects)
    projects.each do |project|
      project_backers_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{project.url}/backers"))
      project.video_url = project_backers_page.xpath("//meta[@property='twitter:player:stream']/@content").text
      project.save
    end
  end

  def self.scrape(projects)
    projects.each do |project|
      if project.scraped
        puts "already scraped #{project.url}"
        next
      else
        project_backers_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{project.url}/backers"))
        project_backers_page.css(".NS_backers__backing_row").each do |row|
          user_url = row.css("a").attr("href").value
          user = KsUser.find_or_create_by(:url => user_url)
          project.add_user(user)
          puts "scraped #{user_url}"
        end
        project.title = project_backers_page.xpath("//meta[@property='og:title']/@content").text
        project.creator_id = project_backers_page.xpath("//meta[@property='kickstarter:creator']/@content").text.split(/\//).last
        project.description = project_backers_page.xpath("//meta[@property='og:description']/@content").text
        project.parent_category = project_backers_page.xpath("//li['@class=category']/@data-project-parent-category").text
        project.category = project_backers_page.css("div.NS-project_-running_board li.category").text.strip
        project.funding_goal = project_backers_page.xpath("//div['@id=pledged']/@data-goal").text.to_i
        project.pledged = project_backers_page.xpath("//div['@id=pledged']/@data-pledged").text.to_i
        project.latitude = project_backers_page.xpath("//meta[@property='kickstarter:location:latitude']/@content").text
        project.longitude = project_backers_page.xpath("//meta[@property='kickstarter:location:longitude']/@content").text
        project.end_date = project_backers_page.xpath("//h5 ['@class=poll']/@data-end_time").text
        project.updates_count = project_backers_page.xpath("//span['@id=updates_count']/@data-updates-count").text.to_i
        project.comments_count = project_backers_page.xpath("//span['@id=comments_count']/@data-comments-count").text.to_i
        project.backer_count = project_backers_page.xpath("//data['@itemprop=Project[backers_count]']/@data-value").first.value.to_i
        project.image_url = project_backers_page.xpath("//meta[@property='og:image']/@content").text
      end

      if project.save
        project.scraped = true 
        project.save 
      else
        puts "there was an error"
      end
    puts "   finished scraping #{project.title}, #{project.id}"
    end
  end

  def self.find_duplicates(range)
    projects = KsProject.where(:id => range)
    projects.select do |project|
      KsProject.where(:url => project.url).size > 1
    end
  end

  def self.clean_duplicates(dups)
    # find all of the ks_project_ids for a given url
    # collect all of the users that have backed it in total
    # check each user to see if a ks_project_backer relation has been created for the original project
    # if not, create the record
    # if so, move on
    
    dups.each do |duplicate|
      group_of_same = KsProject.where(:url => duplicate.url)
      orig = group_of_same.min_by { |p| p.id }

      backers = group_of_same.collect do |clone|
        clone.ks_users
      end.flatten.uniq

      backers.each do |user|
        orig.ks_users.find_or_create_by(:url => user.url)
      end
      orig.save

      group_of_same.reject! { |p| p.id == orig.id }
      group_of_same.each do |clone|
        clone.destroy
      end
    end
  end


end
