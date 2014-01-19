class BuysellItemCategorySubcategory < ActiveRecord::Base
  attr_accessible :buysell_item_category_id, :buysell_item_subcategory_id

  belongs_to :buysell_item_category
  belongs_to :buysell_item_subcategory
end
