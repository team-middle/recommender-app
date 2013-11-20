class AddCategoryScoreColumnsToKsUsers < ActiveRecord::Migration
  def change
    add_column :ks_users, :art_score, :integer, default: 0
    add_column :ks_users, :comics_score, :integer, default: 0
    add_column :ks_users, :dance_score, :integer, default: 0
    add_column :ks_users, :design_score, :integer, default: 0 
    add_column :ks_users, :fashion_score, :integer, default: 0
    add_column :ks_users, :film_score, :integer, default: 0
    add_column :ks_users, :food_score, :integer, default: 0
    add_column :ks_users, :games_score, :integer, default: 0
    add_column :ks_users, :music_score, :integer, default: 0
    add_column :ks_users, :photography_score, :integer, default: 0
    add_column :ks_users, :publishing_score, :integer, default: 0
    add_column :ks_users, :tech_score, :integer, default: 0
    add_column :ks_users, :theater_score, :integer, default: 0

  end
end
