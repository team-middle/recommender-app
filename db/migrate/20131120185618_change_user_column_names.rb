class ChangeUserColumnNames < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :c1, :art_score
      t.rename :c2, :comics_score
      t.rename :c3, :dance_score
      t.rename :c4, :design_score
      t.rename :c5, :fashion_score
      t.rename :c6, :film_score
      t.rename :c7, :food_score
      t.rename :c8, :games_score
      t.rename :c9, :music_score
      t.rename :c10, :photography_score
      t.rename :c11, :publishing_score
      t.rename :c12, :technology_score
      t.rename :c13, :theater_score
    end
    add_column :users, :center_id, :integer
  end
end
