class AddCenterIdToKsUsers < ActiveRecord::Migration
  def change
    add_column :ks_users, :center_id, :integer
  end
end
