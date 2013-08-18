class AddPrivacyToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :privacy, :string
  end
end
