class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.boolean :privacy
      t.integer :creator
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :all_day

      t.timestamps
    end
    add_index :events, [:creator, :created_at, :starts_at, :ends_at], :name => "index_evts_on_crtor_and_crted_and_starts_and_ends"
  end
end
