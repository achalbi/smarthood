class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start_date_time
      t.boolean :privacy
      t.integer :creator

      t.timestamps
    end
    add_index :events, [:creator, :created_at, :start_date_time]
  end
end
