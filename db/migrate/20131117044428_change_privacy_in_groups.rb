class ChangePrivacyInGroups < ActiveRecord::Migration
  def change
    change_column :groups, :privacy, :integer
  end
end
