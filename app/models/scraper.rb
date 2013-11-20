require 'open-uri'
class Scraper
  def backed_projects(url)
    user_page = Nokogiri::HTML(open("http://www.kickstarter.com/profile/#{url}"))

# coffee.css(".NS_backers__backing_row").last.css("a").attr("href").value

    urls_for_backed_projects = user_page.css("a.project_item").collect do |project|
      project.attr('href')
    end
 #project.category = project_backers_page.css("div.NS-project_-running_board li.category").text.stripfunded_projects
     urls_for_backed_projects
  end

end
