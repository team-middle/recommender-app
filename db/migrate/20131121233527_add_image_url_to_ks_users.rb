class AddImageUrlToKsUsers < ActiveRecord::Migration
  def change
    add_column :ks_users, :image_url, :string
  end
end
