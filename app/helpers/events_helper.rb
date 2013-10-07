module EventsHelper

	def active_community_events
		@events = Event.scoped
		if session['events_scope'] == 'active'
			@events = @events.where('community_id = ?',active_community.id)
		elsif session['events_scope'] == 'my'
			@events = Event.where('id IN (?)', current_user.eventdetails.collect(&:event_id))
		end
		@events
	end
end
