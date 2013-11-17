class RemovePrivacyFromGroup < ActiveRecord::Migration
  def up
    remove_column :groups, :privacy
  end

  def down
    add_column :groups, :privacy, :string
  end
end
