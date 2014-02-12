class CommunitiesController < ApplicationController
  include PhotosHelper, UsersHelper, CommunityHelper, ActivitynotificationsHelper
  before_filter :signed_in_user, only: [:create, :destroy]

  def new
  	@community = Community.new
  end

  def index
    @selected_community = nil
    @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
    unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
      @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
      @my_communities = Community.where(['id IN (?) and id!=?', current_user.communities.collect(&:id),@selected_community.id]) 
    end
    @public_communities = Community.where(['id  NOT IN (?)' , current_user.communities.collect(&:id)]) 
    @posts = nil
    @post = Post.new
    @requested_users = nil
    unless @selected_community.nil?
      @ad_eds = @selected_community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
      @non_ad_eds = @selected_community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
      @users = @non_ad_eds.pluck(:user_id)
      @admin_users = @ad_eds.pluck(:user_id)
      @inv_users = User.where(['id IN (?)', @users])
      @ad_users = User.where(['id IN (?)', @admin_users])
      @requested_users = nil
      @ucs = @selected_community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )

      @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @selected_community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
      #@posts = @selected_community.posts.paginate(page: params[:page], :per_page => 4)
      if @ucs.count > 0
        @requested_users = User.where(['id IN (?)' , @selected_community.requested_uc.collect(&:user_id)])
        @selected_community.req_pending_cnt = @requested_users.count
      end  
    end
    @users_pp = []
    @ucs_all = current_user.usercommunities.where("is_admin=?", true )
    @my_mod_communities = Community.where(['id IN (?)', @ucs_all.collect(&:community_id)]) 
    @requested_users_all = 0
    @my_mod_communities.each do |community|
      @requested_users_all += User.where(['id IN (?)' , community.requested_uc.collect(&:user_id)]).count
    end
    @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
    @ucs = @selected_community.usercommunities unless @selected_community.nil?
  	@community = @selected_community
  end


  def create
   @community = current_user.communities.build(params[:community])
   @community.user = current_user
   if @community.save
    if @community.photo.nil?
      @photo = Photo.new
      @photo.remote_pic_url = "http://res.cloudinary.com/rashi/image/upload/v1379775358/comUnity_uxui7t.jpg"
      @photo.save
      @community.photo = @photo 
    end
    @community.save
      #flash[:success] = "community created!"
      @usercommunity = @community.follow!(current_user, @community.id)
      @usercommunity.invitation= Uc_enum::JOINED
      @usercommunity.is_admin = true
      @usercommunities = Usercommunity.where(['status=? and user_id=?','active',current_user.id])
      @usercommunities.each do |uc|
        if uc.status=="active"
          uc.status=""
          uc.save
        end
      end 
      @usercommunity.status="active"
      @usercommunity.save
      createNotificationSettings(active_community.id)
    @selected_comm  = []
    @selected_comm << active_community
    @post = Post.new
     @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
      getNotifiableUsers(Objecttypeenum::COMUNITY, @community, nil, nil, Uc_enum::CREATED)

  else
    #	flash[:error] = "community not created!"
  end 
  respond_to do |format|
   format.html { redirect_to :action => :index   }
   format.js { }
 end

end

def update
  @community = Community.find(params[:id])
  @community.update_attributes(params[:community])
  @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
  @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
  @users = @non_ad_eds.pluck(:user_id)
  @admin_users = @ad_eds.pluck(:user_id)
  @inv_users = User.where(['id IN (?)', @users])
  @ad_users = User.where(['id IN (?)', @admin_users])
  @requested_users = nil
  @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
    @community.req_pending_cnt = @requested_users.count
  end  
  @ucs = @community.usercommunities
  @selected_comm  = []
  @selected_comm << active_community
  @post = Post.new
   @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, nil, nil, Uc_enum::UPDATED)

end

def setactive
 @uc_count = current_user.usercommunities.where('status=?','active').count
 @usercommunity = Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0]
 unless @usercommunity.nil?
  @usercommunity.status=""
  @usercommunity.save
end
@usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',params[:id],current_user.id])[0]
@usercommunitySel.status="active"
@usercommunitySel.save
@selected_comm  = []
@selected_comm << active_community
@post = Post.new
 @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << active_community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
if @uc_count < 1
  render js: %(window.location.href='#{root_path}')
end
end

def sendrequest
 @usercommunity = Usercommunity.new 
 @usercommunity.community_id = params[:id]
 @usercommunity.user_id = current_user.id
 @usercommunity.invitation = Uc_enum::REQUESTED
 @usercommunity.is_admin = false
 @usercommunity.status=""
 @usercommunity.save
 @community = Community.find(params[:id])
 getNotifiableUsers(Objecttypeenum::COMUNITY, @community, nil, nil, Uc_enum::REQUESTED)

end

def acceptrequest
 @usercommunity = Usercommunity.where(['community_id=? and user_id=?',params[:id],params[:user_id]])[0]
 @usercommunity.invitation = Uc_enum::JOINED
 @usercommunity.save
 @community = Community.find(params[:id])
 @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
 @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
 @users = @non_ad_eds.pluck(:user_id)
 @admin_users = @ad_eds.pluck(:user_id)
 @inv_users = User.where(['id IN (?)', @users])
 @ad_users = User.where(['id IN (?)', @admin_users])
 @requested_users = nil
 @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
  end 
  @usr = User.find(params[:user_id])
  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::ACCEPTED)  
end

def declinerequest
 @usercommunity = Usercommunity.where(['community_id=? and user_id=?',params[:id],params[:user_id]])[0]
 @usercommunity.invitation = Uc_enum::MODERATOR_DECLINED
 @usercommunity.save
 @community = Community.find(params[:id])
 @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
 @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
 @users = @non_ad_eds.pluck(:user_id)
 @admin_users = @ad_eds.pluck(:user_id)
 @inv_users = User.where(['id IN (?)', @users])
 @ad_users = User.where(['id IN (?)', @admin_users])
 @requested_users = nil
 @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
 if @ucs.count > 0
  @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
end   
end

def join_cu
 @usercommunity = Usercommunity.where("community_id = ? AND user_id = ?", params[:id], current_user.id).first
 if @usercommunity.blank?
   @usercommunity = Usercommunity.new 
   @usercommunity.community_id = params[:id]
   @usercommunity.user_id = current_user.id
   @usercommunity.invitation = Uc_enum::JOINED
   @usercommunity.is_admin = false
   @usercommunity.status="active"
   @usercommunity.save
 else
    @usercommunity.invitation = Uc_enum::JOINED
    @usercommunity.save
 end
  unless params[:id].nil?
   
      @notifications_settings = current_user.activitynotificationsettings.where("community_id = ?", params[:id]).first
      if @notifications_settings.blank?
        createNotificationSettings(params[:id])
      end
      @community = Community.find(params[:id])
    getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, current_user, Uc_enum::JOINED)
  
  end
  if @uc_count < 1
    render js: %(window.location.href='#{root_path}')
  end
end

def unjoin_cu
 @usercommunity = current_user.usercommunities.find_by_community_id(params[:id])
 @usercommunity.invitation = Uc_enum::UNJOINED
 @usercommunity.save
 deleteNotificationSettings(params[:id])
end

def show
  @community = Community.find(params[:id])
  @selected_community = @community
  @user = current_user
  @users = @community.users
  @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
  @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
  @users = @non_ad_eds.pluck(:user_id)
  @admin_users = @ad_eds.pluck(:user_id)
  @inv_users = User.where(['id IN (?)', @users])
  @ad_users = User.where(['id IN (?)', @admin_users])
  @requested_users = nil
  @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
    @selected_community.req_pending_cnt = @requested_users.count
  end
  @selected_comm  = []
  @selected_comm << active_community
  @post = Post.new
   @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
  @ucs = @community.usercommunities
  respond_to do |format|
   format.html {  }
   format.js {  }
 end
end

def active_com
  @selected_community = nil
  unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
    @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
  end
  @community = @selected_community  
  @users = @community.users
  @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
  @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
  @users = @non_ad_eds.pluck(:user_id)
  @admin_users = @ad_eds.pluck(:user_id)
  @inv_users = User.where(['id IN (?)', @users])
  @ad_users = User.where(['id IN (?)', @admin_users])
  @requested_users = nil
  @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
  @selected_comm  = []
  @selected_comm << active_community
  @post = Post.new
       @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << active_community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
    @selected_community.req_pending_cnt = @requested_users.count
  end
  @ucs = @community.usercommunities
end

def joined_com
  @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
  unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
    @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
    @ucs = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED )
    @comm_id = @ucs.collect(&:community_id)
    @comm_id << @selected_community.id
    @my_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) 
  end 
  @communities = @my_communities  
end

def moderated_com
  @ucs = current_user.usercommunities.where("is_admin=?", true )
  @communities = []
  @req_pending_cnt = 0
  @my_mod_communities = Community.where(['id IN (?)', @ucs.collect(&:community_id)]) 
  @my_mod_communities.each do |community|
    community.req_pending_cnt = User.where(['id IN (?)' , community.requested_uc.collect(&:user_id)]).count
    @communities << community
  end
end

def public_com
  @public_communities = nil
  if current_user.joined_uc.collect(&:community_id).count > 0 
    @public_communities = Community.where(["id  NOT IN (?) AND privacy = ?" , current_user.joined_uc.collect(&:community_id), Privacyenum::PUBLIC])  
  else
    @public_communities = Community.where("privacy = ?", Privacyenum::PUBLIC) 
  end 
  @communities = @public_communities  
end

def private_com
  @private_communities = nil
  if current_user.joined_uc.collect(&:community_id).count > 0 
    @private_communities = Community.where(["id  NOT IN (?) AND privacy = ?" , current_user.joined_uc.collect(&:community_id), Privacyenum::PRIVATE])   
  else
    @private_communities = Community.where("privacy = ? ", Privacyenum::PRIVATE) 
  end
  @communities = @private_communities  
end

def search_address
  @community = Community.new
  gc = Geocoder.search(params[:address])
  result = gc.collect do |t|
    { value: t.address }
  end
  respond_to do |format|
    format.json {render :json => result}
  end
end

def get_geo_coordinates
  @community = Community.new
  gc = Geocoder.search(params[:address])[0]
  @community.address = gc.address
  @community.latitude = gc.latitude
  @community.longitude = gc.longitude
end

def search_app_user
  @users = User.where("name like ? AND id != ?", "%#{params[:q]}%", current_user.id)
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

    def search_fb_user
      @friends = fb_friends
      @users_pp = []
      @friends.each do |friend|
        friend[:profile_pic] =  fb_profile_pic_url(friend.id, friend.name, size: 40)
        if friend.include? params[:q]
          friend.id = friend.id << "_fb"
          @users_pp << friend
        end
      end
      respond_to do |format|
        format.html
        format.json { render :json => @users_pp.map(&:attributes) }
      end
    end

    def search_app_fb_user
      @users = User.where("name like ?", "%#{params[:q]}%")
      @users_pp = []
      @users.each do |user|
        app_user = Array.new(1) { Hash.new }
        app_user[0]["id"] = user.id
        app_user[0]["name"] = user.name 
        app_user[0]["profile_pic"] =  gravatar_for_url(user, size: 40)
        @users_pp << app_user[0]
      end
      @friends = fb_friends
      @friends.each do |friend|
        friend["profile_pic"] =  fb_profile_pic_url(friend["id"], size: 40)
        if friend["name"].downcase.include? params[:q].downcase
          friend["id"] = friend["id"] << "_fb"
          @users_pp << friend
        end
      end
      respond_to do |format|
        format.html
        format.json { render :json => @users_pp.to_json(:method => ['id', 'name', 'profile_pic']) }
      end
    end

   def invite_app_user
      unless params[:community][:user_tokens].nil?
        @user_ids = params[:community][:user_tokens].split(",")
        @community = Community.find(params[:id])
        @user_ids.each do |id|
          @usercommunity = Usercommunity.where('community_id=? and user_id=?',params[:id],id)[0]
         if @usercommunity.blank?
           @usercommunity = Usercommunity.new 
           @usercommunity.community_id = params[:id]
           @usercommunity.user_id = id
           @usercommunity.is_admin = false
           @usercommunity.status=""
           @usercommunity.invitation = Uc_enum::INVITED
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::INVITED)
         elsif (@usercommunity.invitation==Uc_enum::REQUESTED || @usercommunity.invitation==Uc_enum::MODERATOR_DECLINED)
           @usercommunity.invitation = Uc_enum::JOINED
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::ACCEPTED)
         elsif @usercommunity.invitation == Uc_enum::USER_DECLINED
           @usercommunity.invitation = Uc_enum::INVITED
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::INVITED)

         end
           @usercommunity.save
       end
      end 
  end

 def invite_fb_friends
    @fb_uids = params[:ids].split(",")
    @fb_uids.each do |uid|
      @user = create_user_to_invite(uid,nil)
      @usercommunity = Usercommunity.where('community_id=? and user_id=?',params[:id],@user.id)[0]
      if @usercommunity.blank?
       @usercommunity = Usercommunity.new 
       @usercommunity.community_id = params[:id]
       @usercommunity.user_id = @user.id
       @usercommunity.is_admin = false
       @usercommunity.status=""
       @usercommunity.invitation = Uc_enum::INVITED
     elsif (@usercommunity.invitation==Uc_enum::REQUESTED || @usercommunity.invitation==Uc_enum::MODERATOR_DECLINED)
       @usercommunity.invitation = Uc_enum::JOINED
     elsif @usercommunity.invitation == Uc_enum::USER_DECLINED
       @usercommunity.invitation = Uc_enum::INVITED
     end
       @usercommunity.save
   end
 end

 def invite_by_email
   @email_ids = params[:community][:user_tokens].split(",")
    @email_ids.each do |eid|
      @user = create_user_to_invite(nil,eid)
      if @user.id == current_user.id
        next
      end
      @usercommunity = Usercommunity.where('community_id=? and user_id=?',params[:id],@user.id)[0]
     if @usercommunity.nil?
       @usercommunity = Usercommunity.new 
       @usercommunity.community_id = params[:id]
       @usercommunity.user_id = @user.id
       @usercommunity.is_admin = false
       @usercommunity.status=""
       @usercommunity.invitation = Uc_enum::INVITED
     elsif (@usercommunity.invitation==Uc_enum::REQUESTED || @usercommunity.invitation==Uc_enum::MODERATOR_DECLINED)
       @usercommunity.invitation = Uc_enum::JOINED
     elsif @usercommunity.invitation == Uc_enum::USER_DECLINED
       @usercommunity.invitation = Uc_enum::INVITED
     end
       @usercommunity.save
   end
 end

 def add_moderators
    Usercommunity.where("community_id = ? AND user_id IN (?)", params[:id], params[:user_all_ids]).update_all(is_admin: false)
    Usercommunity.where("community_id = ? AND user_id IN (?)", params[:id], params[:user_ids]).update_all(is_admin: true)
    @users = User.where("user_id IN (?)", params[:user_ids])
    @community = Community.find(params[:id])
      @users.each do |usr|
        getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, usr, Uc_enum::ADD_MODERATOR)
      end
 end

   def community_post_paginate
    @selected_comm  = []
    @community = Community.find(params[:id])
    @selected_comm << @community
    @post = Post.new
    @posts = @community.posts.paginate(page: params[:page], :per_page => 4).uniq
  end

  def posts_com
    @selected_comm  = []
    @community = Community.find(params[:id])
    @selected_community = @community
    @selected_comm << @community
    @post = Post.new
       @group_ids = current_user.user_groups.where("community_id = ?", @selected_community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
  end

  def about_com
    @community = Community.find(params[:id])
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
  end

  def photos_com
    @community = Community.find(params[:id])
    @albums = @community.albums
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
  end

 def members_com
    @community = Community.find(params[:id])
    @ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, true )
    @non_ad_eds = @community.usercommunities.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED, false)
    @users = @non_ad_eds.pluck(:user_id)
    @admin_users = @ad_eds.pluck(:user_id)
    @inv_users = User.where(['id IN (?)', @users])
    @ad_users = User.where(['id IN (?)', @admin_users])
    @requested_users = nil
    @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
    if @ucs.count > 0
      @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
      @community.req_pending_cnt = @requested_users.count
    end 
    @ucs = @community.usercommunities
 end

 def groups_com
    @community = Community.find(params[:id])
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
    @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @selected_community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
    @my_groups = Group.where('id IN (?)', @my_groups_ids)
    @other_groups = Group.where("community_id = ? AND id NOT IN (?)", @selected_community.id, @my_groups_ids)
    debugger
    debugger
    @groups
 end

 def create_album
     @com = Community.find(params[:id])
    @album = current_user.albums.build(params[:album])
        @album.save
        @photos = params[:photos][:pic]
        @photos.each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @album.photos << @photo
          end
        @album.save
        @com.albums << @album
        @com.save
        @albums = @com.albums
        getNotifiableUsers(Objecttypeenum::ALBUM, @album, nil, nil, Uc_enum::CREATED)
        #flash[:success] = "Album created"
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end

def cu_list
  
end

end
