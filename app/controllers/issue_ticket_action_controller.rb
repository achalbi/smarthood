class IssueTicketActionController < ApplicationController
  def destroy
  	@action = IssueTicketAction.find(params[:id])
    @action.destroy
      @issue = IssueTracker.new
      @issues = IssueTracker.all.reverse
      @ticket_actions = TicketAction.all
  end

  def update
  end
end
