module EventsHelper

	def active_community_events
		@events = Event.scoped
		@events = @events.where('community_id = ?',active_community.id)
	end
	
end
