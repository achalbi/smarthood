class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :share_id
      t.integer :album_id
      t.string :type
      t.datetime :creation_date

      t.timestamps
    end
  end
end
