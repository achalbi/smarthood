class AddPrivacyToEvent < ActiveRecord::Migration
  def change
    add_column :events, :privacy, :integer
  end
end
