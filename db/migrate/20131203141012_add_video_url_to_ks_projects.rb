class AddVideoUrlToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :video_url, :string
  end
end
