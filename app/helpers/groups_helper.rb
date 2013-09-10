module GroupsHelper

	def active_community_user_groups
		@groups = Group.where('community_id = ?',active_community.id)
		@groups = @groups.where(:id => current_user.user_groups.collect(&:group_id)) 
	end

	def active_community_groups
		@groups = Group.where('community_id = ?',active_community.id)
	end

end
