class AddPostableActionToPost < ActiveRecord::Migration
  def change
    add_column :posts, :postable_action, :string
  end
end
