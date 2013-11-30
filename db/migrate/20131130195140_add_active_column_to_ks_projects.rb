class AddActiveColumnToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :active, :boolean
  end
end
