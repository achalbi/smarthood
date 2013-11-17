class RemovePrivacyFromCommunity < ActiveRecord::Migration
  def up
    remove_column :communities, :privacy
  end

  def down
    add_column :communities, :privacy, :string
  end
end
