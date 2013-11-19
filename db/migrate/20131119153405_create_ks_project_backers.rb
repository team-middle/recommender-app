class CreateKsProjectBackers < ActiveRecord::Migration
  def change
    create_table :ks_project_backers do |t|
      t.references :ks_users, index: true
      t.references :ks_projects, index: true
    end
  end
end
