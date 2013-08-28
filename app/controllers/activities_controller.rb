class ActivitiesController < ApplicationController
  def new
  end

    def create
    @et = Event.find(params[:activity][:event_id])
    @activity = @et.activities.build(params[:activity])

      @act_user = @activity.user_ids
      @act_group = @activity.group_ids
      @act_user.each do |user_id|
        @user_act = Activitydetail.new
        @user_act.is_admin=false
        @user_act.user = User.find(user_id)
        @activity.activitydetails << @user_act
      end
      @act_group.each do |group_id|
        @group_act = Activitydetail.new
        @group_act.is_admin = false
        @group_act.group = Group.find(group_id)
        @activity.activitydetails << @group_act
      end
    
    @activity.save
   # @event = Event.find(params[:activity][:event_id])
    @activities = @et.activities
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
    @posts = @activity.posts.order("id DESC").all
=begin    
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
=end

    @ad_eds = @activity.activitydetails.where(is_admin: true )
    @non_ad_eds = @activity.activitydetails.where(is_admin: false)
    @groups = @non_ad_eds.pluck(:group_id)
    @users = @non_ad_eds.pluck(:user_id)
    @admin_groups = @ad_eds.pluck(:group_id)
    @admin_users = @ad_eds.pluck(:user_id)
    @inv_groups = Group.where(['id IN (?)', @groups])
    @ad_groups = Group.where(['id IN (?)', @admin_groups])
    @inv_users = User.where(['id IN (?)', @users])
    @ad_users = User.where(['id IN (?)', @admin_users])
    @album = Album.new
    @albums = @activity.albums
    #debugger
    @event2 = @event
    unless @activity.is_admin
      @event = @activity
    end
  end


  def create_album
     @activity = Activity.find(params[:id])
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
        @album = Album.new
          flash[:success] = "Album created"
        #debugger
    
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end

end
