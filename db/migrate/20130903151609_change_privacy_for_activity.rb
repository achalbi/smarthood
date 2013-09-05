class ChangePrivacyForActivity < ActiveRecord::Migration
  def up
  	change_table :activities do |t|
      t.change :privacy, :integer
    end
  end

  def down
  	change_table :activities do |t|
      t.change :privacy, :string
    end
  end
end
