class RemovePrivacyFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :privacy
  end

  def down
    add_column :events, :privacy, :string
  end
end
