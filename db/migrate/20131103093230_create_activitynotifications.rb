class CreateActivitynotifications < ActiveRecord::Migration
  def change
    create_table :activitynotifications do |t|
      t.boolean :is_unread
      t.boolean :is_hidden
      t.integer :recepient_id
      t.integer :sender_id
      t.string :objecttype
      t.string :Activitynotificationtype
      t.string :body_html
      t.string :body_text
      t.string :href

      t.timestamps
    end
  end
end
