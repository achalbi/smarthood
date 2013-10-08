class EventsController < ApplicationController
  include UsersHelper, EventsHelper, GroupsHelper 
  require 'open-uri'
  helper_method :sort_column, :sort_direction
  autocomplete :name, :extra_data => [:email]

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
      if @event.starts_at.nil?
        @event.starts_at = Time.zone.now
      end
      if @event.ends_at.nil?
        @event.ends_at = Time.zone.now
      end
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
      #debugger
      @activity = Activity.new
      @activity.title="Main"
      @activity.description = "Event's main activity"
      @activity.is_admin = true
      @activity.save
      @event.activities << @activity
      @ed_user = @event.user_ids
      @ed_group = @event.group_ids
      @ed_user.each do |user_id|
        @user_ed = Eventdetail.new
        @user_ed.is_admin=false
        @user_ed.user = User.find(user_id)
        @event.eventdetails << @user_ed
      end
      @ed_group.each do |group_id|
        @grp = Group.find(group_id)
        @grp.users.each do |user|
          @group_ed = Eventdetail.new
          @group_ed.is_admin = false
          @group_ed.group = @grp
          @group_ed.user = user
          @event.eventdetails << @group_ed
        end
      end
      @event.community_id = active_community.id
      respond_to do |format|
        if @event.save
          @event.eventdetails.create(user_id: current_user.id, is_admin: true)
        #  format.html { redirect_to @event, format: 'js', :success => 'Event was successfully created.' }
          format.json { render :json => @event, :status => :created, :location => @event }
          format.js { redirect_to(:action => :show, :format => :js, :id => @event.id)} #redirect_to @event, format: :js, :success => 'Event was successfully created.' }
        else
          format.html { render :action => "index" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    end

    def index
      unless params[:events_scope].nil?
        session['events_scope'] = params[:events_scope] 
      end
      @event = Event.new
      @event.starts_at = Time.zone.now
      @event.ends_at = Time.zone.now
      @events = active_community_events
      @events = @events.between(params['start'], params['end']) if (params['start'] && params['end'])
      @upcoming_events = @events.where("starts_at > ?",Time.current.tomorrow.to_date).order("id DESC")
      @past_events = @events.where("starts_at < ? and ends_at < ?",Time.current.to_date,Time.current.to_date).order("id DESC")
      @today_events = @events.where("starts_at BETWEEN ? AND ?",Time.current.to_date,Time.current.tomorrow.to_date).order("id DESC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @upcoming_events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
      @today_events = @today_events.paginate(:page => params[:page], :per_page => 5)
      @past_events = @past_events.paginate(:page => params[:page], :per_page => 5)
      #ip_loc = Geocoder.search(remote_ip)[0]

     # @event.address = ip_loc.address
     # @event.latitude = ip_loc.latitude
     # @event.longitude = ip_loc.longitude
     # result = request.location
      respond_to do |format|
        format.html {session['events_scope'] = 'all'}# index.html.erb
        format.json { render :json => @events }
        format.js 
      end
    end

      def search_auto_user
        @users = User.where("name like ?", "%#{params[:q]}%")
        # debugger
        @users_pp = []
        @users.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
       end
      # debugger
        respond_to do |format|
          format.html
          format.json { render :json => @users_pp.map(&:attributes) }
        end
      end

      def search_auto_group
        @groups = active_community_groups.where("name like ?", "%#{params[:q]}%")
        @groups_pp = []
        @groups.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
       end
        respond_to do |format|
          format.html
          format.json { render :json => @groups_pp.map(&:attributes) }
        end
      end 

    def search_selected_user
        @event = Event.find(params[:id])
        @ur_ids = @event.eventdetails.pluck(:user_id)
        @urs = User.where(['id IN (?)', @ur_ids])
        @users = @urs.where("name like ?", "%#{params[:q]}%")
        @users_pp = []
        @users.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
        
      end
      respond_to do |format|
          format.html
          format.json { render :json => @users_pp.map(&:attributes) }
        end
    end

    def search_selected_group
      @event = Event.find(params[:id])
      @grp_ids = @event.eventdetails.pluck(:group_id)
      @grps = Group.where(['id IN (?)', @grp_ids])
      @groups = @grps.where("name like ?", "%#{params[:q]}%")
      @groups_pp = []
      @groups.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
      end
        respond_to do |format|
          format.html
          format.json { render :json => @groups_pp.map(&:attributes) }
        end
      end 

    def upcoming_events_paginate
      @events = active_community_events
      @upcoming_events = @events.where("starts_at > ?",Time.current.tomorrow.to_date).order("id DESC")
      @events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
    end

    def today_events_paginate
       @events = active_community_events
       @today_events = @events.where("starts_at BETWEEN ? AND ?",Time.current.to_date,Time.current.tomorrow.to_date).order("id DESC")
       @events = @today_events.paginate(:page => params[:page], :per_page => 5)
    end

    def past_events_paginate
      @events = active_community_events
      @past_events = @events.where("starts_at < ? and ends_at < ?",Time.current.to_date,Time.current.to_date).order("id DESC")
      @events = @past_events.paginate(:page => params[:page], :per_page => 5)
    end

    def post_paginate
      @activity = Activity.find(params[:id])
      @event = Event.find(params[:event_id])
      @activities = @event.activities
      if @activity.is_admin
        @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
      else
       @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
      end 
    end

    def show
    @event = Event.find(params[:id])
    @album = Album.new
    @ad_eds = @event.eventdetails.where(is_admin: true )
    @non_ad_eds = @event.eventdetails.where(is_admin: false)
    @groups = @non_ad_eds.pluck(:group_id)
    @users = @non_ad_eds.pluck(:user_id)
    @admin_groups = @ad_eds.pluck(:group_id)
    @admin_users = @ad_eds.pluck(:user_id)
    @inv_groups = Group.where(['id IN (?)', @groups])
    @ad_groups = Group.where(['id IN (?)', @admin_groups])
    @inv_users = User.where(['id IN (?)', @users])
    @ad_users = User.where(['id IN (?)', @admin_users])
    @activities = @event.activities
    @activity = @event.activities.where(is_admin: true).first
    @albums = @activity.albums
    @share = Share.new
    @ur_ids = @event.eventdetails.pluck(:user_id)
        @urs = User.where(['id IN (?)', @ur_ids])
        @users = @urs.where("name like ?", "%#{params[:q]}%")
        @users_pp = []
      @users.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
      end
    @grp_ids = @event.eventdetails.pluck(:group_id)
    @grps = Group.where(['id IN (?)', @grp_ids])
    @groups = @grps.where("name like ?", "%#{params[:q]}%")
      @groups_pp = []
      @groups.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
      end
    @mod_users = @inv_users
      @grps.each do |group|
      #  @mod_users |= group.users
      end
      @activities = @event.activities
      @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
    @post = Post.new
    @comment = Comment.new
    if @event.photo.nil?
      #@photo = Photo.find_by_pic("v1378556932/events_medium_m4h4ww.jpg")
      if @event.photo.nil?
      @photo = Photo.new
      @photo.remote_pic_url = "http://res.cloudinary.com/rashi/image/upload/v1378556932/events_medium_m4h4ww.jpg"
      @photo.save
      @event.photo = @photo 
      end
       @event.save
      # debugger
    end
=begin
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
rescue Exception => e
  
=end 
    @is_event = true        
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
      format.js
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
    @event_temp = current_user.events.build(params[:event])
    unless params[:user_ids].nil?
      @users_ids = params[:user_ids]
        @users_ids.each do |usr_id|
          @evt_dts_u = @event.eventdetails.find_by_user_id(usr_id)
          if @evt_dts_u.nil?
           
           else
          @evt_dts_u.is_admin=true
          @evt_dts_u.save
            
          end
        end
    end
    unless params[:group_ids].nil?
       @groups_ids = params[:group_ids]
        @groups_ids.each do |grp_id|
          @evt_dts_g=@event.eventdetails.find_by_group_id(grp_id)
          @evt_dts_g.is_admin=true
          @evt_dts_g.save
        end
    end

    @ed_user = @event_temp.user_ids
    @ed_group = @event_temp.group_ids
    unless @ed_user.nil? 
      @ed_user.each do |user_id|
        @user_ed = Eventdetail.new
        @user_ed.is_admin=false
          if @event.eventdetails.pluck(:user_id).detect {|n| n==user_id}.nil?
            @user_ed.user = User.find(user_id)
            @event.eventdetails << @user_ed
          end
      end
    end
    unless @ed_group.nil? 
      @ed_group.each do |group_id|
       if @event.eventdetails.pluck(:group_id).detect {|n| n==group_id}.nil?
        @grp = Group.find(group_id)
        @grp.users.each do |user|
          @group_ed = Eventdetail.new
          @group_ed.is_admin = false
          @group_ed.group = @grp
          @group_ed.user = user
          @event.eventdetails << @group_ed
        end
       end
      end
    end
    @event.update_attributes(params[:event])
    @ad_eds = @event.eventdetails.where(is_admin: true )
    @non_ad_eds = @event.eventdetails.where(is_admin: false)
    @groups = @non_ad_eds.pluck(:group_id)
    @users = @non_ad_eds.pluck(:user_id)
    @admin_groups = @ad_eds.pluck(:group_id)
    @admin_users = @ad_eds.pluck(:user_id)
    @inv_groups = Group.where(['id IN (?)', @groups])
    @ad_groups = Group.where(['id IN (?)', @admin_groups])
    @inv_users = User.where(['id IN (?)', @users])
    @ad_users = User.where(['id IN (?)', @admin_users])
    @ur_ids = @event.eventdetails.pluck(:user_id)
        @urs = User.where(['id IN (?)', @ur_ids])
        @users = @urs.where("name like ?", "%#{params[:q]}%")
        @users_pp = []
      @users.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
      end

    @grp_ids = @event.eventdetails.pluck(:group_id)
    @grps = Group.where(['id IN (?)', @grp_ids])
    @groups = @grps.where("name like ?", "%#{params[:q]}%")
      @groups_pp = []
      @groups.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
      end    
      @mod_users = @inv_users
      @grps.each do |group|
     #   @mod_users |= group.users
      end
     # debugger
     @is_event = true
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
        format.js {}
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

    def search_user_group
        @event = Event.new
        @user = User.search(params[:location], nil)
        #@group = Group.search(params[:location])
        result = @user.collect do |t|
          { value: t.name }
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
