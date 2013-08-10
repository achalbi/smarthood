class ChangeStringInEvents < ActiveRecord::Migration
	def change
		remove_index "events", ["creator", "created_at", "starts_at", "ends_at"]
    	change_column :events, :privacy, :string
		add_index "events", ["creator", "created_at", "starts_at", "ends_at"], :name => "inx_evnts"
  	end
end
