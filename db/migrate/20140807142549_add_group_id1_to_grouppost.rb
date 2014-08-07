class AddGroupId1ToGrouppost < ActiveRecord::Migration
  def change
  	remove_index(:groupposts, name: 'index_groupposts_on_group_id')
  	remove_index(:groupposts, name: 'index_groupposts_on_post_id_and_group_id')
  	remove_index(:groupposts, name: 'index_groupposts_on_post_id')
  end
end
