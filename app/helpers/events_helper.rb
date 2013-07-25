module EventsHelper

	def active_community_events
		@events = Event.where('community_id = ?',active_community.id)
	end
	
end
