class AddEndDateToKsProjects < ActiveRecord::Migration
  def change
    add_column :ks_projects, :end_date, :string
  end
end
