class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.integer :home_town
      t.integer :current_city
      t.datetime :dob
      t.string :gender
      t.string :mobile
      t.string :work
      t.string :education
      t.string :relationship_status
      t.string :app_url
      t.string :website
      t.integer :sn_link

      t.timestamps
    end
  end
end
