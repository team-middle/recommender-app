class AddImageUrlToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :image_url, :string
  end
end
