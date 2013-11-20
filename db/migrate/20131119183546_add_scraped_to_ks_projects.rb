class AddScrapedToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :scraped, :boolean
  end
end
