class AddPrivacyToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :privacy, :integer
  end
end
