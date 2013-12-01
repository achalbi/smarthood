class ChangePrivacyInEvents < ActiveRecord::Migration
  def change
    change_column :events, :privacy, :integer
  end
end
