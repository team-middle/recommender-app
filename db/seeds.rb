# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'
require 'nokogiri'
require 'pry'

# def scrape_user_page(url)
#   user_page = Nokogiri::HTML(open(url))
#   projects = user_page.css("ul li.page")
#   binding.pry
# end
url = ("/profile/teruterubouzu")
# scrape_user_page(page)


user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))

# coffee.css(".NS_backers__backing_row").last.css("a").attr("href").value
user = KsUser.create(:url => url)

urls_for_backed_projects = user_page.css("a.project_item").collect do |project|
  project_url = project.attr('href')
  ks_project = KsProject.create(:url => project_url)
  user.ks_project_backers.create(:ks_project => ks_project)
end


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
