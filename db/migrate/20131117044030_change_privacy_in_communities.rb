class ChangePrivacyInCommunities < ActiveRecord::Migration
  def change
    change_column :communities, :privacy, :integer
  end
end
