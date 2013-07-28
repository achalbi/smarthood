class EventsController < ApplicationController
	helper_method :sort_column, :sort_direction

  def new
    @group_ids = nil
    @user_ids = nil
    @editor_group_ids = nil
    @editor_user_ids = nil
  	@event = Event.new
    if !params[:p_invite_groups].nil?
       @group_ids = params[:p_invite_groups].keys.collect(&:to_i)
    end
    if !params[:p_invite_users].nil?
       @user_ids = params[:p_invite_users].keys.collect(&:to_i)
    end
    if !params[:p_editor_groups].nil?
       @editor_group_ids = params[:p_editor_groups].keys.collect(&:to_i)
    end
    if !params[:p_editor_users].nil?
       @editor_user_ids = params[:p_editor_users].keys.collect(&:to_i)
    end
    	@invite_groups = Group.search(params[:search1], @group_ids).order(sort_column(params[:sort1]) + ' ' + sort_direction(params[:direction1]))  
    	@editor_groups = Group.search(params[:search2], @editor_group_ids).order(sort_column(params[:sort2]) + ' ' + sort_direction(params[:direction2]))  
      @invite_users = User.search(params[:search3], @user_ids).order(sort_column(params[:sort3]) + ' ' + sort_direction(params[:direction3]))   
      @editor_users = User.search(params[:search4], @editor_user_ids).order(sort_column(params[:sort4]) + ' ' + sort_direction(params[:direction4]))  
      

    respond_to do |format|
      format.html {render layout: "app_full"}
      if !@group_ids.nil?
        format.js {render partial: "inv_gp"}
      elsif !@user_ids.nil?
        format.js {render partial: "inv_usr"}
      elsif !@editor_group_ids.nil?
        format.js {render partial: "ed_gp"}
      elsif !@editor_user_ids.nil?
        format.js {render partial: "ed_usr"}
      end
    end

  end

   	def create
      @event = current_user.events.build(params[:event])
=begin
  


        if !params[:invite_groups].nil?
          @invited_groups = Group.find(params[:invite_groups].keys.collect(&:to_i))  
        end
        if !params[:editor_groups].nil?
          @editor_groups = Group.find(params[:editor_groups].keys.collect(&:to_i))
        end
        if !params[:invite_users].nil?
        @invited_users = User.find(params[:invite_users].keys.collect(&:to_i))
        end
        if !params[:editor_users].nil?
        @editor_users = User.find(params[:editor_users].keys.collect(&:to_i))
        end

        if @event.save
          if !@invited_groups.nil?
            @invited_groups.each do |invited_group|
              @event.invited_groups << invited_group
            end
          end
          if !@invited_users.nil?
            @invited_users.each do |invited_user|
              @event.invited_users << invited_user
            end
          end
          if !@editor_groups.nil?
            @editor_groups.each do |editor_group|
              @event.editor_groups << editor_group
            end
          end
          if !@editor_users.nil?
            @editor_users.each do |editor_user|
              @event.editor_users << editor_user
            end
          end  

        end
        
rescue Exception => e
  
=end    
      @event.community_id = active_community.id
      respond_to do |format|
        if @event.save
          format.html { redirect_to @event, :success => 'Event was successfully created.' }
          format.json { render :json => @event, :status => :created, :location => @event }
        else
          format.html { render :action => "new" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    end

    def index
      @event = Event.new
      @events = Event.scoped
      @events = @events.between(params['start'], params['end']) if (params['start'] && params['end'])
      @events = @events.where('community_id = ?',active_community.id)
      @upcoming_events = @events.where("starts_at > ?",Time.current.tomorrow.to_date)
      @past_events = @events.where("starts_at < ? and ends_at < ?",Time.current.to_date,Time.current.to_date)
      @today_events = @events.where("starts_at BETWEEN ? AND ?",Time.current.to_date,Time.current.tomorrow.to_date)
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @upcoming_events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
      @today_events = @today_events.paginate(:page => params[:page], :per_page => 5)
      @past_events = @past_events.paginate(:page => params[:page], :per_page => 5)
      #ip_loc = Geocoder.search(remote_ip)[0]
     # debugger
     # @event.address = ip_loc.address
     # @event.latitude = ip_loc.latitude
     # @event.longitude = ip_loc.longitude
    #  result = request.location
    # debugger
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @events }
      end
    end

    def show
    @event = Event.find(params[:id])
    @evt = Event.find(params[:id])
    @activities = @evt.activities
    @group_ids = nil
    @user_ids = nil
    @editor_group_ids = nil
    @editor_user_ids = nil
    if !params[:p_invite_groups].nil?
       @group_ids = params[:p_invite_groups].keys.collect(&:to_i)
    end
    if !params[:p_invite_users].nil?
       @user_ids = params[:p_invite_users].keys.collect(&:to_i)
    end
    if !params[:p_editor_groups].nil?
       @editor_group_ids = params[:p_editor_groups].keys.collect(&:to_i)
    end
    if !params[:p_editor_users].nil?
       @editor_user_ids = params[:p_editor_users].keys.collect(&:to_i)
    end
  @invite_groups = Group.search(params[:search1], @group_ids).order(sort_column(params[:sort1]) + ' ' + sort_direction(params[:direction1]))  
  @editor_groups = Group.search(params[:search2], @editor_group_ids).order(sort_column(params[:sort2]) + ' ' + sort_direction(params[:direction2]))  
  @invite_users = User.search(params[:search3], @user_ids).order(sort_column(params[:sort3]) + ' ' + sort_direction(params[:direction3]))   
  @editor_users = User.search(params[:search4], @editor_user_ids).order(sort_column(params[:sort4]) + ' ' + sort_direction(params[:direction4]))  

  @event_inv_gp = @event.invited_groups.pluck(:group_id)
  @event_ed_gp = @event.editor_groups.pluck(:group_id)
  @event_inv_usr = @event.invited_users.pluck(:user_id)
  @event_ed_usr = @event.editor_users.pluck(:user_id)

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

        @posts = []
       if !@evt.activities.nil?
            @evt.activities.each do |activity|
                @posts |= activity.posts
            end
       end 
       @my_posts = []
       @posts.each do |post|
            if post.user == current_user
                @my_posts << post
            end
        end
        
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
 end

  def edit
    @event = Event.find(params[:id])
    @evt = Event.find(params[:id])
    @activities = @evt.activities
    @group_ids = nil
    @user_ids = nil
    @editor_group_ids = nil
    @editor_user_ids = nil
    if !params[:p_invite_groups].nil?
       @group_ids = params[:p_invite_groups].keys.collect(&:to_i)
    end
    if !params[:p_invite_users].nil?
       @user_ids = params[:p_invite_users].keys.collect(&:to_i)
    end
    if !params[:p_editor_groups].nil?
       @editor_group_ids = params[:p_editor_groups].keys.collect(&:to_i)
    end
    if !params[:p_editor_users].nil?
       @editor_user_ids = params[:p_editor_users].keys.collect(&:to_i)
    end
  @invite_groups = Group.search(params[:search1], @group_ids).order(sort_column(params[:sort1]) + ' ' + sort_direction(params[:direction1]))  
  @editor_groups = Group.search(params[:search2], @editor_group_ids).order(sort_column(params[:sort2]) + ' ' + sort_direction(params[:direction2]))  
  @invite_users = User.search(params[:search3], @user_ids).order(sort_column(params[:sort3]) + ' ' + sort_direction(params[:direction3]))   
  @editor_users = User.search(params[:search4], @editor_user_ids).order(sort_column(params[:sort4]) + ' ' + sort_direction(params[:direction4]))  

  @event_inv_gp = @event.invited_groups.pluck(:group_id)
  @event_ed_gp = @event.editor_groups.pluck(:group_id)
  @event_inv_usr = @event.invited_users.pluck(:user_id)
  @event_ed_usr = @event.editor_users.pluck(:user_id)

        respond_to do |format|
      format.html # edit.html.erb
      format.json { render :json => @event }
    end

  end 
   # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

    # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def search_address
        @event = Event.new
        gc = Geocoder.search(params[:address])
        result = gc.collect do |t|
          { value: t.address }
        end
        respond_to do |format|
            format.json {render :json => result}
        end
  end

  def get_geo_coordinates
    @event = Event.new
    gc = Geocoder.search(params[:address])[0]
      @event.address = gc.address
      @event.latitude = gc.latitude
      @event.longitude = gc.longitude
  end

  private
  def sort_column(sort)
	Group.column_names.include?(sort) ? sort : "name"
  end  
    
  def sort_direction(direction)
     %w[asc desc].include?(direction) ?  direction : "asc"   
  end  



end
