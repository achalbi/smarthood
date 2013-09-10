class RemovePrivacyFromActivity < ActiveRecord::Migration
  def up
    remove_column :activities, :privacy
  end

  def down
    add_column :activities, :privacy, :string
  end
end
