user_page = Nokogiri::HTML(open("http://www.kickstarter.com/#{url}"))

# coffee.css(".NS_backers__backing_row").last.css("a").attr("href").value
user = KsUser.find_or_create_by(:url => url)

urls_for_backed_projects = user_page.css("a.project_item").collect do |project|
  project_url = project.attr('href')
  ks_project = KsProject.find_or_create_by(:url => project_url)
  user.ks_project_backers.find_or_create_by(:ks_project => ks_project)
  puts "scraped #{ks_project.url}"
end

project.category = project_backers_page.css("div.NS-project_-running_board li.category").text.strip