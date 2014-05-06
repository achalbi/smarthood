class RemovePostableActionfromPost < ActiveRecord::Migration
  def up
    remove_column :posts, :postable_action
  end

  def down
    add_column :posts, :postable_action, :string
  end
end
