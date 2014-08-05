class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :starts_at
    add_index :events, :community_id
  end
end
