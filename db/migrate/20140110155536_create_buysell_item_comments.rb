class CreateBuysellItemComments < ActiveRecord::Migration
  def change
    create_table :buysell_item_comments do |t|
      t.integer :buysell_item_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
