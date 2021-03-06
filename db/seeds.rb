# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# def scrape_user_page(url)
#   user_page = Nokogiri::HTML(open(url))
#   projects = user_page.css("ul li.page")
#   binding.pry
# end
require 'open-uri'

# url = ("/profile/teruterubouzu")
# scrape_user_page(page)


# user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))

# # coffee.css(".NS_backers__backing_row").last.css("a").attr("href").value
# user = KsUser.find_or_create_by(:url => url)

# urls_for_backed_projects = user_page.css("a.project_item").collect do |project|
#   project_url = project.attr('href')
#   ks_project = KsProject.find_or_create_by(:url => project_url)
#   user.ks_project_backers.find_or_create_by(:ks_project => ks_project)
#   puts "scraped #{ks_project.url}"
# end

# projects = KsProject.all
# ks5000 = KsProject.where(id: (1000..5000))
# ks5000.each do |project|
#   if project.scraped
#     puts "already scraped #{project.url}"
#     next
#   else
#     project_backers_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{project.url}/backers"))
#     project_backers_page.css(".NS_backers__backing_row").each do |row|
#       user_url = row.css("a").attr("href").value
#       user = KsUser.find_or_create_by(:url => user_url)
#       project.add_user
#       puts "scraped #{user_url}"
#     end
#     project.title = project_backers_page.xpath("//meta[@property='og:title']/@content").text
#     project.creator_id = project_backers_page.xpath("//meta[@property='kickstarter:creator']/@content").text.split(/\//).last
#     project.description = project_backers_page.xpath("//meta[@property='og:description']/@content").text
#     project.parent_category = project_backers_page.xpath("//li['@class=category']/@data-project-parent-category").text
#     project.category = project_backers_page.css("div.NS-project_-running_board li.category").text.strip
#     project.funding_goal = project_backers_page.xpath("//div['@id=pledged']/@data-goal").text.to_i
#     project.pledged = project_backers_page.xpath("//div['@id=pledged']/@data-pledged").text.to_i
#     project.latitude = project_backers_page.xpath("//meta[@property='kickstarter:location:latitude']/@content").text
#     project.longitude = project_backers_page.xpath("//meta[@property='kickstarter:location:longitude']/@content").text
#     project.end_date = project_backers_page.xpath("//h5 ['@class=poll']/@data-end_time").text
#     project.updates_count = project_backers_page.xpath("//span['@id=updates_count']/@data-updates-count").text.to_i
#     project.comments_count = project_backers_page.xpath("//span['@id=comments_count']/@data-comments-count").text.to_i
#     project.backer_count = project_backers_page.xpath("//data['@itemprop=Project[backers_count]']/@data-value").first.value.to_i
#     project.image_url = project_backers_page.xpath("//meta[@property='og:image']/@content").text

#   end

#   if project.save
#     project.scraped = true 
#     project.save 
#   else
#     puts "there was an error"
#   end
# puts "   finished scraping #{project.title}, #{project.id}"
# end

# users = KsUser.where("id<1000")
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
## extra user scrape
# url = user.url
# user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))
# user.image_url = user_page.xpath("//meta[@property='og:image']/@content").text
# user.name = user_page.xpath("//meta[@property='kickstarter:name']/@content").text
# user.joined = user_page.xpath("//meta[@property='kickstarter:joined']/@content").text
# user.description = user_page.xpath("//meta[@property='og:description']/@content").text
# user.location = user_page.css("span.location").text
# user.save



10.times do 
# for a list of users:
# take a URL and go to a user page

# scrape user data
  # stuff into database
# go to each of their backed projects
# scrape data from main project page
# go to backer page of project
# scrape user URL
# repeat



end
