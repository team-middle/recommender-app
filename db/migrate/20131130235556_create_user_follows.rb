class CreateUserFollows < ActiveRecord::Migration
  def change
    create_table :user_follows do |t|
      t.belongs_to :user
      t.belongs_to :ks_user

      t.timestamps
    end
  end
end
