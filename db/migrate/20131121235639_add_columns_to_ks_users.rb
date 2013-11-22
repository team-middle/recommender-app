class AddColumnsToKsUsers < ActiveRecord::Migration
  def change
    add_column :ks_users, :name, :string
    add_column :ks_users, :joined, :string
    add_column :ks_users, :description, :string
    add_column :ks_users, :location, :string
  end
end
