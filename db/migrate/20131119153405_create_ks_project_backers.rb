class CreateKsProjectBackers < ActiveRecord::Migration
  def change
    create_table :ks_project_backers do |t|
      t.references :ks_user, index: true
      t.references :ks_project, index: true
    end
  end
end
