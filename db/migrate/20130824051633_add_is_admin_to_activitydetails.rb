class AddIsAdminToActivitydetails < ActiveRecord::Migration
  def change
    add_column :activitydetails, :is_admin, :boolean
  end
end
