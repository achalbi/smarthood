class CreateUserlikes < ActiveRecord::Migration
  def change
    create_table :userlikes do |t|
      t.integer :user_id
      t.integer :likeable_id
      t.string :likeable_type

      t.timestamps
    end
  end
end
