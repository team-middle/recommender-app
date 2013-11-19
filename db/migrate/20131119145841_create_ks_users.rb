class CreateKsUsers < ActiveRecord::Migration
  def change
    create_table :ks_users do |t|
      t.string :url
      t.boolean :scraped
      # the url gets me everything else
    end
  end
end
