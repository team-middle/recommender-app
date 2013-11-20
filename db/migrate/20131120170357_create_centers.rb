class CreateCenters < ActiveRecord::Migration
  def change
    create_table :centers do |t|
      t.integer :art_score, default: 0
      t.integer :comics_score, default: 0
      t.integer :dance_score, default: 0
      t.integer :design_score,  default: 0
      t.integer :fashion_score, default: 0
      t.integer :film_score, default: 0
      t.integer :food_score, default: 0
      t.integer :games_score, default: 0
      t.integer :music_score, default: 0
      t.integer :photography_score, default: 0
      t.integer :publishing_score, default: 0
      t.integer :technology_score, default: 0
      t.integer :theater_score, default: 0
    end
  end
end
