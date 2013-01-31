class AddGroupIdToGroupposts < ActiveRecord::Migration
  def change
    add_column :groupposts, :group_id, :string
  end
end
