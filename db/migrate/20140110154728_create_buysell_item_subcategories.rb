class CreateBuysellItemSubcategories < ActiveRecord::Migration
  def change
    create_table :buysell_item_subcategories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
