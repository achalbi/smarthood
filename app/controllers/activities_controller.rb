class ActivitiesController < ApplicationController
  include UsersHelper, ActivitynotificationsHelper
  
  def new
  end

    def create
    @et = Event.find(params[:activity][:event_id])
    @activity = @et.activities.build(params[:activity])
        @ad = Activitydetail.new
        @ad.is_admin=true
        @ad.user = current_user
        @activity.activitydetails << @ad
    if @activity.privacy==Privacyenum::PUBLIC
    else
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
    end
    @activity.save
      if @activity.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.content = "<span class='timestamp' style='font-size:15px;'> added an activity </span><strong><a href='/activities/" + @activity.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @activity.title + " </a></strong><span class='timestamp' style='font-size:15px;'> to the event </span><strong><a href='/events/" + @et.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @et.title + " </a>.</strong>"
        @post.user_id = current_user.id
        @post.postable = @activity
        @post.save
        @post.communities << active_community 
        @post.photos << @et.photo
      end
    getNotifiableUsers(Objecttypeenum::ACTIVITY, @activity, nil, nil, Uc_enum::CREATED)
    @activities = @et.activities
    #flash[:success] = "Activity created!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :event => @event } }
      end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @event = Event.find(@activity.event_id)
     Activity.find(params[:id]).destroy
    #flash[:success] = "Activity destroyed!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :event => @event } }
      end
  end

  def show
    @activity = Activity.find(params[:id]) 
    @event = Event.find(@activity.event_id)
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @urs = @eds.pluck(:user_id).uniq - @ads.pluck(:user_id).uniq
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)
=begin
    @post = Post.new
    @posts = @activity.posts.order("id DESC").all
       @ad_eds 
       @non_ad_eds
    if @activity.privacy == Privacyenum::PUBLIC
     # @ad_eds = @event.eventdetails.where(is_admin: true )
      @non_ad_eds = @event.eventdetails #.where(is_admin: false)     
    else
     # @ad_eds = @activity.activitydetails.where(is_admin: true )
      @non_ad_eds = @activity.activitydetails #.where(is_admin: false)   
    end
    @group_ids = @non_ad_eds.pluck(:group_id)
    @users = @non_ad_eds.pluck(:user_id)
     @urs = User.where(['id IN (?)', @users])
     @users1 = @urs.where("name like ?", "%#{params[:q]}%")
    @users_pp = []
      @users1.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
      end
      @grps = Group.where(['id IN (?)', @group_ids])
      @groups1 = @grps.where("name like ?", "%#{params[:q]}%")
    @groups_pp = []
      @groups1.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
      end
    @ad_users=[]
    @ad_groups=[]
    @inv_groups = Group.where(['id IN (?)', @group_ids])
    @inv_users = User.where(['id IN (?)', @users])
    @album = Album.new
    @albums = @activity.albums
    @is_event = false
    @event2 = @event
    unless @activity.is_admin
      @event = @activity
    end
=end

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
        getNotifiableUsers(Objecttypeenum::ALBUM, @album, nil, nil, Uc_enum::CREATED)
        @album = Album.new
        #  flash[:success] = "Album created"
      @share = Share.new
    #  if @activity.is_admin?
    #    getNotifiableUsers(Objecttypeenum::ALBUM, @album, Objecttypeenum::EVENT, @activity.event, Uc_enum::CREATED)
    #  else
    #    getNotifiableUsers(Objecttypeenum::ALBUM, @album, Objecttypeenum::ACTIVITY, @activity, Uc_enum::CREATED)
    #  end
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end
  def update

    @activity = Activity.find(params[:id])
    @event = @activity.event
    @activity.update_attributes(params[:activity])
    @activities = @event.activities
    
=begin
    @event2 = Event.find(params[:activity][:event_id])
    @activity =Activity.find(params[:id])
    @activity.update_attributes(params[:activity])
    @act_users = @activity.user_ids
    @activity.activitydetails.where(['user_id Not IN (?)', @act_users]).delete_all
    @act_groups = @activity.group_ids
    @activity.activitydetails.where(['group_id Not IN (?)', @act_groups]).delete_all
    unless @act_users.nil? 
      @act_users.each do |user_id|
        @user_act = Activitydetail.new
        @user_act.is_admin=false
          if @activity.activitydetails.pluck(:user_id).detect {|n| n==user_id}.nil?
            @user_act.user = User.find(user_id)
            @activity.activitydetails << @user_act
          end
      end
    end
    unless @act_groups.nil? 
      @act_groups.each do |group_id|
        @group_act = Activitydetail.new
        @group_act.is_admin = false
          if @activity.activitydetails.pluck(:group_id).detect {|n| n==group_id}.nil?
            @group_act.group = Group.find(group_id)
            @activity.activitydetails << @group_act
          end
      end
    end
    @non_ad_eds = @activity.activitydetails
    @groups = @non_ad_eds.pluck(:group_id)
    @users = @non_ad_eds.pluck(:user_id)
     @urs = User.where(['id IN (?)', @users])
     @users1 = @urs.where("name like ?", "%#{params[:q]}%")
    @users_pp = []
      @users1.each do |user|
        user[:profile_pic] =  gravatar_for_url(user, size: 40)
        @users_pp << user
      end
      @grps = Group.where(['id IN (?)', @groups])
      @groups1 = @grps.where("name like ?", "%#{params[:q]}%")
    @groups_pp = []
      @groups1.each do |group|
        group[:profile_pic] = group.photo.pic_url(:smaller)
        @groups_pp << group
      end
    @ad_users = []
    @ad_groups = []
    @inv_users = User.where(['id IN (?)', @users])
    @inv_groups = Group.where(['id IN (?)', @groups])
    @event = @activity
    @activities = @event2.activities
    @is_event = false
    @album = Album.new
=end


    #getNotifiableUsers(Objecttypeenum::ACTIVITY, @activity, nil, nil, Uc_enum::UPDATED)
  end

end
