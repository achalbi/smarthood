class AddIsAdminToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :is_admin, :boolean
  end
end
