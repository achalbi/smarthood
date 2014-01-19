class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :doorno
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.string :postalcode

      t.timestamps
    end
  end
end
