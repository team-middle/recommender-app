class AddDescriptionToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :description, :string
  end
end
