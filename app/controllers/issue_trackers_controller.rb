class IssueTrackersController < ApplicationController
  def new
  end

  def index
    TicketAction.create(description: "Opened")
    TicketAction.create(description: "Resolved")
    TicketAction.create(description: "Wont-Fix")
    TicketAction.create(description: "Invalid")
    TicketAction.create(description: "Re-opened")
    TicketAction.create(description: "Not Reproducible")
    TicketAction.create(description: "Closed")
    TicketAction.create(description: "Comment")
    @issue = IssueTracker.new
    @issues = IssueTracker.all
    @ticket_actions = TicketAction.all
    @ta = TicketAction.where(description: "Comment")
    @ticket_actions = @ticket_actions.delete_if { |obj| @ta.include?(obj)}
  end

  def create
    @issue = IssueTracker.create(params[:issue_tracker])
    @issue.ticket_id = "CU_"+IssueTracker.last.id.to_s
    @issue.author = current_user
    @issue.assignee = User.find_by_email("achal.rvce@gmail.com")
    @issue.status = @issue.issue_ticket_actions[0].ticket_action.description
     unless params[:photos].nil?
        params[:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @issue.issue_ticket_actions[0].photos << @photo
        end
      end
    @issue.save
    @issue
  end

  def show
    @issue = IssueTracker.find(params[:id])
  end

  def update
    @issue = IssueTracker.find(params[:id])
    @issue.update_attributes(params[:issue_tracker])
    unless params[:photos].nil?
        params[:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @issue.issue_ticket_actions.last!.photos << @photo
        end
    end
    unless @issue.issue_ticket_actions.last!.ticket_action.description == "Comment"
      @issue.status = @issue.issue_ticket_actions.last!.ticket_action.description
    end
    @issue.save
  end

    def destroy
      @issue = IssueTracker.find(params[:id])
      @issue.destroy
      @issue = IssueTracker.new
      @issues = IssueTracker.all
      @ticket_actions = TicketAction.all
    end

    def update_action
      @action = IssueTicketAction.find(params[:issue_ticket_action][:id])
      @action.update_attributes(params[:issue_ticket_action])
      @issue = @action.issue_tracker
      unless @action.ticket_action.description == "Comment"
        @issue.status = @action.ticket_action.description
      end
      @issue.save
    end

    def quick_filter
      @issues = IssueTracker
      unless params[:issue_type].nil?
        @issues = @issues.where(issue_type: params[:issue_type])
      end
      unless params[:module].nil?
        @issues = @issues.where(module: params[:module]) 
      end
      unless params[:priority].nil?
        @issues = @issues.where(priority: params[:priority]) 
      end
      unless params[:severity].nil?
        @issues = @issues.where(severity: params[:severity])
      end
      unless params[:status].nil?
        @issues = @issues.where(status: params[:status]) 
      end
      @issues = @issues.all


    end
end
