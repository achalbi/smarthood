class ActivitiesController < ApplicationController
  def new
  end

    def create
    @et = Event.find(params[:activity][:event_id])
    @activity = @et.activities.build(params[:activity])
    @activity.save
    @evt = Event.find(params[:activity][:event_id])
    @activities = @evt.activities
    flash[:success] = "Activity created!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :event => @event } }
      end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @event = Event.find(@activity.event_id)
     Activity.find(params[:id]).destroy
    flash[:success] = "Activity destroyed!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :event => @event } }
      end
  end

  def show
    @activity = Activity.find(params[:id]) 
    @event = Event.find(@activity.event_id)
    @post = Post.new
    @invited_groups_users=[]
    @editor_groups_users=[]
    @invited_groups = @event.invited_groups
    @invited_groups.group.each do |invited_group|
    @invited_groups_users |= invited_group.users
    end

    @editor_groups = @event.editor_groups
    @editor_groups.group.each do |editor_group|
    @editor_groups_users |= editor_group.users
    end

    @inv_users = []
    @ed_users = []
    @invited_users = @event.invited_users
    @editor_users = @event.editor_users

    if !@invited_groups_users.nil?
      @invited_groups_users.each do |invited_groups_user|
          @inv_users << invited_groups_user
      end
    end  
    if !@editor_groups_users.nil?  
      @editor_groups_users.each do |editor_groups_user|
          @ed_users << editor_groups_user
      end 
    end
    if !@invited_users.nil?   
      @invited_users.each do |invited_user|
          @inv_users << invited_user
      end 
    end
    if !@editor_users.nil?       
      @editor_users.each do |editor_user|
          @ed_users << editor_user
      end 
    end
    @ed_users = @ed_users.uniq
    @inv_users = @inv_users.uniq
  end
end
