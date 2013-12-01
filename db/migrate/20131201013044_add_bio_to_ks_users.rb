class AddBioToKsUsers < ActiveRecord::Migration
  def change
    add_column :ks_users, :bio, :text
  end
end
