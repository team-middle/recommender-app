class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c5
      t.integer :c6
      t.integer :c7
      t.integer :c8
      t.integer :c9
      t.integer :c10
      t.integer :c11
      t.integer :c12
      t.integer :c13

      t.timestamps
    end
  end
end
