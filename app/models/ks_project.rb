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
    projects = KsProject.where(:scraped => true).limit(1000) 
    active_projects = projects.select { |p| p.still_active? }
    active_projects.sample
  end

  def ending_soon?

  end

  def add_user(user)
    # if !KsProjectBacker.where(:ks_project => self).where(:ks_user => user).empty?
    #   binding.pry
    #   return
    # else
      self.ks_project_backers.find_or_create_by(:ks_user => user)
      self.save
    # end
  end

  def self.scrape_without_users(projects)
    projects.each do |project|
      if project.scraped
        puts "already scraped #{project.url}"
        next
      else
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

end

#Ruby
# 0year, 1month, 2day, 3hour, 4min, 5sec, 6utc_offset
#KS 
# "Sun, 28 Oct 2012 06:59:00 -0000"
#0weekday/junk, 1day, 2month, 3year, 4houretc, 5utc