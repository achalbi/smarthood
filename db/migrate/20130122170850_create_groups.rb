class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :privacy
      t.integer :User_id

      t.timestamps
    end
    add_index :groups, :User_id
  end
end
