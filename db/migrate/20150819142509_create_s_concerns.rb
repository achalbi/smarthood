class CreateSConcerns < ActiveRecord::Migration
  def change
    create_table :s_concerns do |t|
      t.string :content
      t.string :status

      t.timestamps
    end
  end
end
