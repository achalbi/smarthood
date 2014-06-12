class EventsController < ApplicationController
  include UsersHelper, EventsHelper, GroupsHelper, ActivitynotificationsHelper
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
      #@event.community_id = active_community.id
      @event.save   
      @activity = Activity.new
      @activity.event_id = @event.id
      @activity.title=@event.title
      @activity.description = "Main Event"
      @activity.is_admin = true
      @activity.save
      @event.activities << @activity

       @event.eventdetails.create(user_id: current_user.id, is_admin: true, status: "yes")


      if @event.photo.nil?
        @photo = Photo.new
        @photo.remote_pic_url = "http://res.cloudinary.com/rashi/image/upload/v1378556932/events_medium_m4h4ww.jpg"
        @photo.save
        @event.photo = @photo 
      end

      if @event.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.title = "<span class='timestamp' style='font-size:15px;'> added event </span><strong><a href='/events/" + @event.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @event.title + " </a>.</strong>"
        @post.content = ""
        @post.user_id = current_user.id
        @post.postable = @event
        @post.save
        @post.communities << active_community 
        @post.photos << @event.photo
      end

      respond_to do |format|
        if @event.save
        #  getNotifiableUsers(Objecttypeenum::EVENT, @event, nil, nil, Uc_enum::CREATED)
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
      @event.starts_at = Time.zone.now.beginning_of_day
      @event.ends_at = Time.zone.now.end_of_day
      @events = active_community_events
      @events = @events.between(params['start'], params['end']) if (params['start'] && params['end'])
      #@upcoming_events = @events.where("starts_at > ?",Time.current.tomorrow.to_date).order("id DESC")
      @upcoming_events = @events.where("starts_at > ?",Time.zone.now.beginning_of_day- 1.second).order("starts_at ASC").paginate(page: params[:page], :per_page => 5)
      @past_events = @events.where("starts_at < ? ",Time.zone.now.beginning_of_day).order("starts_at DESC").paginate(page: params[:page], :per_page => 5)
      #@past_events = @events.where("starts_at < ? and ends_at < ?",Time.current.to_date,Time.current.to_date).order("id DESC")
      #@today_events = @events.where("starts_at BETWEEN ? AND ?",Time.current.to_date,Time.current.tomorrow.to_date).order("id DESC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      #@upcoming_events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
      #@today_events = @today_events.paginate(:page => params[:page], :per_page => 5)
      #@past_events = @past_events.paginate(:page => params[:page], :per_page => 5)
      #ip_loc = Geocoder.search(remote_ip)[0]

     # @event.address = ip_loc.address
     # @event.latitude = ip_loc.latitude
     # @event.longitude = ip_loc.longitude
     # result = request.location

      @invited_events = []
      Eventdetail.where("user_id = ? AND status = ?", current_user.id, 'invited' ).find_each do |ed|
        @invited_events << ed.event
      end

      respond_to do |format|
        format.html {session['events_scope'] = 'all'}# index.html.erb
        format.json { render :json => @events }
        format.js 
      end
    end

      def search_auto_user
        @users = User.where("name like ?", "%#{params[:q]}%")
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

      def search_auto_group
        @group_ids = current_user.user_groups.pluck(:group_id).uniq
        @groups = Group.where("id in (?) AND name like ?", @group_ids, "%#{params[:q]}%")
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
      @upcoming_events =  @events.where("starts_at > ?",Time.zone.now.beginning_of_day- 1.second).order("starts_at ASC").paginate(page: params[:page], :per_page => 5)
      @events = @upcoming_events.paginate(:page => params[:page], :per_page => 5)
    end

    def today_events_paginate
       @events = active_community_events
       @today_events = @events.where("starts_at BETWEEN ? AND ?",Time.current.to_date,Time.current.tomorrow.to_date).order("id DESC")
       @events = @today_events.paginate(:page => params[:page], :per_page => 5)
    end

    def past_events_paginate
      @events = active_community_events
      @past_events =  @events.where("starts_at < ? ",Time.zone.now.beginning_of_day).order("starts_at DESC").paginate(page: params[:page], :per_page => 5)
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
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
    #@post = Post.new
    #@posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
    @activities = @event.activities
    @activity = @event.activities.where(is_admin: true).first
    
=begin

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
    end
    @is_event = true       
=end
 
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
    @eds = @event.eventdetails
    @event.update_attributes(params[:event])
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
=begin
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
=end


     @is_event = true
    respond_to do |format|
      if @event.update_attributes(params[:event])
        getNotifiableUsers(Objecttypeenum::EVENT, @event, nil, nil, Uc_enum::UPDATED)
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
        format.js { redirect_to(:action => :show, :format => :js, :id => @event.id)}
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
      format.js { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def update_event
    @event = Event.find(params[:id])
    @eds = @event.eventdetails
    @event.update_attributes(params[:event])
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
    redirect_to(:action => :show, :format => :js, :id => @event.id)
    
  end

  def delete_activity
    @activity = Activity.find(params[:activity_id])
    @event = @activity.event
    @activity.destroy
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
    @activities = @event.activities
    render :action => :show 
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


  def event_posts
      @event = Event.find(params[:id])
      @activity = Activity.find(params[:activity_id])
      @post = Post.new
      if @activity.is_admin
        @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
      else
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
      end
  end

  def event_posts_page
      @event = Event.find(params[:id])
      @activity = Activity.find(params[:activity_id])
      @post = Post.new
      if @activity.is_admin
        @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
      else
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
      end 
  end

  def create_activity_post
      @event = Event.find(params[:id])
      @activity = Activity.find(params[:activity_id])
      @post = @activity.posts.build(params[:post])
      @post.user = current_user
      @post.save
      unless params[:photo].nil?
        @post.photos << current_user.photos.build(params[:photo])
        @post.save
      end
      @post.communities << active_community 
      @activity.posts << @post
      @post.activityposts[0].update_attributes(:event_id => @activity.event_id)
      @activityposts = Activitypost.where("activity_id = ? ", @activity)
      if @activity.is_admin
        @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
      else
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
      end 
      #getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::ACTIVITY, @activity, Uc_enum::CREATED)
      @post_type = 'activity'
      respond_to do |format|
        format.html { redirect_to @activity, format: 'js' }
         format.js {  }
      end
  end

  def event_members
      @activity = Activity.find(params[:activity_id])
    if @activity.is_admin?
      @event = Event.find(params[:id])
      @eds = @event.eventdetails
      @ad_users = @event.eventdetails.where(" is_admin=?", true)
      @inv_users = @event.eventdetails.where(" is_admin=?", false)
    else
      @event = Event.find(params[:id])
      @eds = @event.eventdetails
      @ads = @activity.activitydetails
      @urs = @eds.pluck(:user_id).uniq - @ads.pluck(:user_id).uniq
      @ad_users = @activity.activitydetails.where(" is_admin=?", true)
      @inv_users = @activity.activitydetails.where(" is_admin=?", false)
    end
  end

  def event_photos
      @activity = Activity.find(params[:activity_id])
      @event = Event.find(params[:id])
      @activities = @event.activities
      store_location
  end

 def add_event_moderators
    @event = Event.find(params[:id])
    @event.eventdetails.where("user_id IN (?)", params[:user_all_ids]).update_all(is_admin: false)
    @event.eventdetails.where("user_id IN (?)", params[:user_ids]).update_all(is_admin: true)
    @users = User.where("id IN (?)", params[:user_ids])
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
      @users.each do |usr|
      #  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, usr, Uc_enum::ADD_MODERATOR)
      end
 end

 def add_activity_guests
    @activity = Activity.find(params[:activity][:id])
    @event = Event.find(params[:id])
    @ed_user = @event.eventdetails.pluck(:user_id).uniq
    @ad_user = @activity.activitydetails.pluck(:user_id).uniq
     @users_ids = params[:user_ids]
        @users_ids.each do |usr_id|
            @ad = Activitydetail.new
            @ad.is_admin = false
            @ad.user_id = usr_id
            @activity.activitydetails << @ad
            
          end
    unless params[:invite_everyone].nil?
        @ed_user = @ed_user - @ad_user
          @ed_user.each do |user_id|
            @ad = Activitydetail.new
            @ad.is_admin = false
            @ad.user_id = user_id
            @activity.activitydetails << @ad
          end
      else
          @user_ids = params[:activity][:user_tokens].split(",").map { |x| x.to_i }
          unless @ed_user.nil?
            @user_ids = @user_ids - @ad_user 
            @user_ids.each do |user_id|
              @ad = Activitydetail.new
              @ad.is_admin = false
              @ad.user_id = user_id
              @activity.activitydetails << @ad
            end
          end
      end
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @urs = @eds.pluck(:user_id).uniq - @ads.pluck(:user_id).uniq
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)
  end

  def unjoin_activity
    @activity = Activity.find(params[:activity_id])
    @activity.activitydetails.find_by_user_id(params[:user_id]).destroy
    @event = Event.find(params[:id])
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @urs = @eds.pluck(:user_id).uniq - @ads.pluck(:user_id).uniq
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)


  end

  def add_activity_moderators
    @event = Event.find(params[:id])
    @activity = Activity.find(params[:activity][:id])
    @activity.activitydetails.where("user_id IN (?)", params[:user_all_ids]).update_all(is_admin: false)
    @activity.activitydetails.where("user_id IN (?)", params[:user_ids]).update_all(is_admin: true)
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @urs = @eds.pluck(:user_id).uniq - @ads.pluck(:user_id).uniq
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)

  end


  def invite_event_guests_by_user
    @event = Event.find(params[:id])
    @eds = @event.eventdetails
    @ed_user = @eds.pluck(:user_id)
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
      unless params[:invite_everyone].nil?
        @communities = Community.where("id IN (?)", current_user.joined_uc.pluck(:community_id).uniq)
        @com_user = []
        @communities.each do | community|
            @com_user += community.usercommunities.where("invitation = ?", Uc_enum::JOINED ).pluck(:user_id)
        end
        @ed_user_add = @com_user - @ed_user
        @ed_user = @ed_user + @ed_user_add
          @ed_user_add.uniq.each do |user_id|
            @event.eventdetails.create(user_id: user_id, is_admin: false, status: "invited")
          end
      else
        unless params[:cu_ids].nil?
          @communities = Community.where('id IN (?)',params[:cu_ids])
          @com_user = []
          @communities.each do | community|
              @com_user += community.usercommunities.where("invitation = ?", Uc_enum::JOINED ).pluck(:user_id)
          end
          @ed_user_add = @com_user - @ed_user
          @ed_user = @ed_user + @ed_user_add
          @ed_user_add.uniq.each do |user_id|
            @event.eventdetails.create(user_id: user_id, is_admin: false, status: "invited")
          end
        end

        @user_ids = params[:event][:user_tokens].split(",").map { |x| x.to_i }
        unless @ed_user.nil?
          @user_ids = @user_ids - @ed_user 
          @ed_user = @user_ids + @ed_user 
        end
        @ed_groups = params[:event][:group_tokens].split(",").map { |x| x.to_i }
          @ed_groups.each do |group_id|
            @grp = Group.find(group_id)
            @ed_users  =  @grp.users.collect(&:id) - @ed_user
            @ed_users.each do |user_id|
              @event.eventdetails.create(user_id: user_id, group_id: @grp.id, is_admin: false, status: "invited")
              #getNotifiableUsers(Objecttypeenum::EVENT, @event, Objecttypeenum::USER, id, Uc_enum::INVITED)
            end
          end
        @user_ids.each do |id|
          @event.eventdetails.create(user_id: id, is_admin: false, status: "invited")
          #getNotifiableUsers(Objecttypeenum::EVENT, @event, Objecttypeenum::USER, id, Uc_enum::INVITED)
        end 
      end
  end

  def invite_event_guests_by_email
    @event = Event.find(params[:id])
    @eds = @event.eventdetails
    @ed_user = @eds.collect(&:user_id)
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
    @email_ids = params[:event][:user_tokens].split(",")
    @email_ids.each do |eid|
      @user = create_user_to_invite(nil,eid)
      if @user.id == current_user.id
        next
      end
      if @ed_user.include?(@user.id)
        next
      end
       @event.eventdetails.create(user_id: @user.id, is_admin: false, status: "invited")
    end
  end

  def invite_fb_friends_to_event
    @community = Community.find(params[:id])
    @event = Event.find(params[:event_id])
     @eds = @event.eventdetails
    @ed_user = @eds.collect(&:user_id)
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
    @fb_uids = params[:ids].split(",")
    @fb_uids.each do |uid|
      @user = create_user_to_invite(uid[0],nil)
      if @ed_user.include?(@user.id)
        next
      end
      @event.eventdetails.create(user_id: @user.id, is_admin: false, status: "invited")
    end
  end

  def search_event_guests
    @event = Event.find(params[:id])
    @user_ids  = @event.eventdetails.pluck(:user_id)
      @users = User.where("LOWER(name) like LOWER(?) AND id != ? AND id IN (?)", "%#{params[:q]}%", current_user.id, @user_ids )
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

    def create_event_album
      @event = Event.find(params[:id])
      @activity = Activity.find(params[:activity_id])
     @album = current_user.albums.build(params[:album])
          # @album.user = current_user
        @album.save
        params[:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @album.photos << @photo
        end
        @album.save
        @activity.albums << @album
        @activity.save
        @albums = @activity.albums
      if @album.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.title = "<span class='timestamp' style='font-size:15px;'>added " + view_context.pluralize(@album.photos.count, "photo") + " to the album </span><strong><a href='/albums/" + @album.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @album.title + " </a></strong>" + "<span class='timestamp' style='font-size:15px;'> under the event </span><strong><a href='/events/" + @event.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @event.title + " </a>.</strong>"
        @post.content = ""
        @post.user_id = current_user.id
        @post.postable = @album
        @post.save
        @post.communities << active_community 
        @album.photos.each do |photo|
          @post.photos << photo
        end
      end
     #   getNotifiableUsers(Objecttypeenum::ALBUM, @album, nil, nil, Uc_enum::CREATED)
        #  flash[:success] = "Album created"
      @share = Share.new
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end

  def event_invitation
    @event = Event.find(params[:id])
    @eds = @event.eventdetails
    @ed_user = @eds.find_by_user_id(current_user.id)
    @ed_user.status = params[:status]
    @ed_user.save
    respond_to do |format|
      if params[:status] == 'yes' || params[:status] == 'maybe'
        format.all { redirect_to(:action => :show, :id => @event.id) }
      else
        format.all { redirect_to :action => :index }
      end
    end
  end



  private
  def sort_column(sort)
	Group.column_names.include?(sort) ? sort : "name"
  end  
    
  def sort_direction(direction)
     %w[asc desc].include?(direction) ?  direction : "asc"   
  end  



end
