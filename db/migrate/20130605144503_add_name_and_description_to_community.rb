class AddNameAndDescriptionToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :name, :string
    add_column :communities, :description, :text
  end
end
