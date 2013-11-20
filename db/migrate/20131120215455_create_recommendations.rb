class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :ks_project, index: true

      t.timestamps
    end
  end
end
