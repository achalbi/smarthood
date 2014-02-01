class AddCommTypeToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :comm_type, :string
  end
end
