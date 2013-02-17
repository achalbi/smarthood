class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :event_id

      t.timestamps
    end
  end
end
