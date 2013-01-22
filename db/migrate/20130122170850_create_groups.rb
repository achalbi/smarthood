class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :privacy
      t.references :User

      t.timestamps
    end
    add_index :groups, :User_id
  end
end
