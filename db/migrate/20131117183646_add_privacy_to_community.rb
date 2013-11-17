class AddPrivacyToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :privacy, :integer
  end
end
