class AddStrengthToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :strength, :integer
  end
end
