class AddUsefulColumnToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :useful, :boolean
  end
end
