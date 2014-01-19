class BuysellItemCategory < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :buysell_item_category_subcategories, dependent: :destroy
  has_many :buysell_item_subcategories, :through => :buysell_item_category_subcategories

    validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
end
