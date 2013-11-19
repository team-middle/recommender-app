class CreateKsProjects < ActiveRecord::Migration
  def change
    create_table :ks_projects do |t|
      t.string :url
      t.integer :backer_count
      t.string :title
      t.string :creator_id
      t.string :parent_category
      t.string :category
      t.integer :funding_goal
      t.integer :pledged
      t.string :latitude
      t.string :longitude
      t.integer :updates_count
      t.integer :comments_count
    end
  end
end
