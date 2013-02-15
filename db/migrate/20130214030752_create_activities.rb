class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start_date_time
      t.integer :event_id

      t.timestamps
    end
  end
end
