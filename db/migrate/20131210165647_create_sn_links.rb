class CreateSnLinks < ActiveRecord::Migration
  def change
    create_table :sn_links do |t|
      t.string :fb
      t.string :twitter
      t.string :google
      t.string :linkedin

      t.timestamps
    end
  end
end
