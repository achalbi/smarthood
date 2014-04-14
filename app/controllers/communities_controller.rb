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

      @group_ids = current_user.user_groups.where("community_id = ? AND invitation = ?", @selected_community.id, Uc_enum::JOINED ).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @selected_community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @selected_community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
      #@posts = @selected_community.posts.paginate(page: params[:page], :per_page => 4)
        @selected_community.req_pending_cnt = 0
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
      @requested_users_all +=  community.requested_uc.collect(&:user_id).size
    end
    @requested_users_all -= @selected_community.req_pending_cnt
    @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
    @inv_req_grps = current_user.invited_groups.collect(&:group_id)
    @ucs = @selected_community.usercommunities unless @selected_community.nil?
  	@community = @selected_community
    @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
    @groups = Group.where('id IN (?)', @my_groups_ids)
    @group = nil
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
      flash[:success] = "community: " + @community.name + " created!"
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
      createNotificationSettings(@community.id, current_user.id)
    @selected_comm  = []
    @selected_comm << @community
    @post = Post.new
     @group_ids = current_user.user_groups.where("community_id = ?", @community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
      getNotifiableUsers(Objecttypeenum::COMUNITY, @community, nil, nil, Uc_enum::CREATED)

  else
    #	flash[:error] = "community: " + @community.name + " not created!"
  end 
  respond_to do |format|
   format.html { redirect_to :action => :index   }
   format.js { }
 end

end

def update
  @community = Community.find(params[:id])
  @community.update_attributes(params[:community])
  flash[:success] = "community: " + @community.name + " updated!"
  @selected_community = @community
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
   @group_ids = current_user.user_groups.where("community_id = ?", @community.id).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, @community.id)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, nil, nil, Uc_enum::UPDATED)

end

def setactive
 @usercommunity = Usercommunity.where(['status=? and user_id=?','active',current_user.id]).first
  unless @usercommunity.nil?
    @usercommunity.status=""
    @usercommunity.save
  end
@usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',params[:id],current_user.id]).first
@usercommunitySel.status="active"
@usercommunitySel.save
@selected_comm  = []
@selected_comm << active_community
@post = Post.new
@community = Community.find(params[:id])
flash[:success] = "community: " + @community.name + " is set as active!"
 @group_ids = current_user.user_groups.where("community_id = ?", params[:id]).collect(&:group_id)
      @post_ids = []
      unless @group_ids.blank?
        @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, params[:id])
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @post_ids = @groupposts.collect(&:post_id)
      end
        @post_ids << @community.posts.collect(&:id)
        @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
if @usercommunity.nil?
  render js: %(window.location.href='#{root_path}')
end
    @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
    @groups = Group.where('id IN (?)', @my_groups_ids)
end

def sendrequest
 @usercommunity = Usercommunity.where("community_id = ? AND user_id = ?", params[:id], current_user.id).first
  if @usercommunity.blank?
     @usercommunity = Usercommunity.new 
     @usercommunity.community_id = params[:id]
     @usercommunity.user_id = current_user.id
     @usercommunity.invitation = Uc_enum::REQUESTED
     @usercommunity.is_admin = false
     @usercommunity.status=""
     @usercommunity.save
   else
    @usercommunity.invitation = Uc_enum::REQUESTED
     @usercommunity.save
  end
 @community = Community.find(params[:id])
 flash[:success] = "Request sent to community: " + @community.name
 getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, current_user, Uc_enum::REQUESTED)

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
 #@group_ids = current_user.invited_groups.collect(&:group_id)
 #@inv_groups = Group.where('id IN (?)', @group_ids)
 @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
 #@inv_req_grps = current_user.invited_groups.collect(&:group_id)
  @ucs_all = current_user.usercommunities.where("is_admin=?", true )
  @my_mod_communities = Community.where(['id IN (?)', @ucs_all.collect(&:community_id)]) 
  @requested_users_all = 0
  @my_mod_communities.each do |community|
     @requested_users_all += community.requested_uc.collect(&:user_id).size
  end
  @requested_users_all -= active_community.requested_uc.collect(&:user_id).size
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
  end 
  #@usr = User.find(params[:user_id])
  @usr = []
  @usr << params[:user_id]
  @notifications_settings = Activitynotificationsetting.where("community_id = ? and user_id = ?", params[:id], params[:user_id]).first
    if @notifications_settings.blank?
      createNotificationSettings(params[:id], params[:user_id])
    end
  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::ACCEPTED)  
end

def declinerequest
 @usercommunity = Usercommunity.where(['community_id=? and user_id=?',params[:id],params[:user_id]])[0]
 if current_user.id = params[:user_id]
   @usercommunity.invitation = Uc_enum::USER_DECLINED
 else
   @usercommunity.invitation = Uc_enum::MODERATOR_DECLINED
 end
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
  @group_ids = current_user.invited_groups.collect(&:group_id)
 @inv_groups = Group.where('id IN (?)', @group_ids)
 @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
 @inv_req_grps = current_user.invited_groups.collect(&:group_id)
  @ucs_all = current_user.usercommunities.where("is_admin=?", true )
  @my_mod_communities = Community.where(['id IN (?)', @ucs_all.collect(&:community_id)])
   @requested_users_all = 0
  @my_mod_communities.each do |community|
     @requested_users_all += community.requested_uc.collect(&:user_id).size
  end
  @requested_users_all -= active_community.requested_uc.collect(&:user_id).size
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
  end 
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
  end   
end

def join_cu
  @usercommunities = Usercommunity.where(['status=? and user_id=?','active',current_user.id])
  unless @usercommunities.blank?
    @usercommunities.each do |uc|
      uc.status=""
      uc.save
    end
  end
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
    @usercommunity.status="active"
    @usercommunity.save
 end
  unless params[:id].nil?
      @notifications_settings = current_user.activitynotificationsettings.where("community_id = ?", params[:id]).first
      if @notifications_settings.blank?
        createNotificationSettings(params[:id], current_user.id)
      end
      @community = Community.find(params[:id])
      flash[:success] = "Joined community: " + @community.name
    getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, current_user, Uc_enum::JOINED)
  
  end
  @uc_count = current_user.usercommunities.where('status=?','active').count
  if @uc_count < 1
    render js: %(window.location.href='#{root_path}')
  end
end

def unjoin_cu
 @user = current_user
 unless params[:user_id].nil?
    @user = User.find(params[:user_id])
 end
 if active_community.id.to_s == params[:id]
    @smarthood_com_id = Community.where(name: 'Smarthood')[0].id
    @usercommunity = @user.usercommunities.find_by_community_id(@smarthood_com_id)
    @usercommunity.status="active"
    @usercommunity.save
 end
 @usercommunity = @user.usercommunities.find_by_community_id(params[:id])
 @usercommunity.invitation = Uc_enum::UNJOINED
 @usercommunity.status=""
 @usercommunity.save
 @community = Community.find(params[:id])
 deleteNotificationSettings(params[:id], @user.id)
 flash[:success] = "Unjoined community: " + @community.name
  unless params[:user_id].nil?
   respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
   end
  end
end


def remove_user_cu
 @user = User.find(params[:user_id])
 @usercommunity = @user.usercommunities.find_by_community_id(params[:id])
  if @usercommunity.status == "active"
    @usercommunity.invitation = Uc_enum::UNJOINED
    @usercommunity.status=""
    @usercommunity.save
    @smarthood_com_id = Community.where(name: 'Smarthood')[0].id
    @usercommunity = @user.usercommunities.find_by_community_id(@smarthood_com_id)
    @usercommunity.status="active"
    @usercommunity.save
  else
    @usercommunity.invitation = Uc_enum::UNJOINED
    @usercommunity.save
  end
 @community = Community.find(params[:id])
 deleteNotificationSettings(params[:id], @user.id)
 #flash[:success] = @user.name + " removed from the community: " + @community.name
  unless params[:user_id].nil?
   respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
   end
  end
end

def show
  @community = Community.find(params[:id])
  # set active - start
  if @community.is_joined?(current_user, @community)
      @usercommunityActive = Usercommunity.where(['status=? and user_id=?','active',current_user.id]).first
      @usercommunityActive.status=""
      @usercommunityActive.save
      @usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',params[:id],current_user.id]).first
      @usercommunitySel.status="active"
      @usercommunitySel.save 
  end 
  # set active - end
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
  @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
  @groups = Group.where('id IN (?)', @my_groups_ids)
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
  @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
  @groups = Group.where('id IN (?)', @my_groups_ids)
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

def my_com
    @mod_comm_id = current_user.usercommunities.where("is_admin = ? AND invitation = ?", true, Uc_enum::JOINED ).collect(&:community_id)
    @active_comm = []
    @active_comm << active_community.id
    @moderated_communities = Community.where(['id IN (?) AND id NOT IN (?)', @mod_comm_id, @active_comm ])
    @moderated_communities.each do |community|
      community.req_pending_cnt = community.requested_uc.collect(&:user_id).size
    end
    @comm_id = current_user.usercommunities.where("is_admin = ? AND invitation = ?", false, Uc_enum::JOINED ).collect(&:community_id)
    @my_communities = Community.where(['id IN (?) AND id NOT IN (?)', @comm_id, @active_comm ])
    @my_communities.each do |community|
      community.req_pending_cnt = community.requested_uc.collect(&:user_id).size
    end
end

def other_com
    @my_comm_id = current_user.usercommunities.where("invitation = ?", Uc_enum::JOINED ).collect(&:community_id).uniq
    @comm_id = Usercommunity.where(" user_id != ?", current_user.id ).collect(&:community_id).uniq
    @communities = Community.where('id IN (?) AND  id NOT IN (?)', @comm_id, @my_comm_id )
end

def moderated_com
  @ucs = current_user.usercommunities.where("is_admin=?", true )
  @communities = []
  @req_pending_cnt = 0
  @my_mod_communities = Community.where(['id IN (?)', @ucs.collect(&:community_id)]) 
  @my_mod_communities.each do |community|
    community.req_pending_cnt = community.requested_uc.collect(&:user_id).size
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
  @users = User.where("LOWER(name) like LOWER(?) AND id != ?", "%#{params[:q]}%", current_user.id)
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
           @usercommunity.save
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::INVITED)
         elsif (@usercommunity.invitation==Uc_enum::REQUESTED || @usercommunity.invitation==Uc_enum::MODERATOR_DECLINED)
           @usercommunity.invitation = Uc_enum::JOINED
           @usercommunity.save
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::ACCEPTED)
         elsif (@usercommunity.invitation == Uc_enum::USER_DECLINED || @usercommunity.invitation == Uc_enum::UNJOINED)
           @usercommunity.invitation = Uc_enum::INVITED
           @usercommunity.save
            @usr = User.find(id)
            getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, @usr, Uc_enum::INVITED)

         end

       end
      end 
  end

 def invite_fb_friends
    @fb_uids = params[:ids].split(",")
    @fb_uids.each do |uid|
      @user = create_user_to_invite(uid[0],nil)
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
     elsif  (@usercommunity.invitation == Uc_enum::USER_DECLINED || @usercommunity.invitation == Uc_enum::UNJOINED)
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
     elsif  (@usercommunity.invitation == Uc_enum::USER_DECLINED || @usercommunity.invitation == Uc_enum::UNJOINED)
       @usercommunity.invitation = Uc_enum::INVITED
     end
       @usercommunity.save
   end
 end

 def add_moderators
    Usercommunity.where("community_id = ? AND user_id IN (?)", params[:id], params[:user_all_ids]).update_all(is_admin: false)
    Usercommunity.where("community_id = ? AND user_id IN (?)", params[:id], params[:user_ids]).update_all(is_admin: true)
    @users = User.where("id IN (?)", params[:user_ids])
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
    @groups = nil
    @group = nil
     @group_ids = current_user.user_groups.where("community_id = ?", params[:id]).collect(&:group_id)
        @post_ids = []
        unless @group_ids.blank?
          @groups = Group.where('id IN (?) AND community_id = ?', @group_ids, params[:id])
          @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
          @post_ids = @groupposts.collect(&:post_id)
        end
          @post_ids << @community.posts.collect(&:id)
          @posts = Post.where(id: @post_ids.uniq).paginate(page: params[:page], :per_page => 4)
  end

  def posts_com
    flash.clear
    unless params[:id].nil?
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
    @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @selected_community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
    @groups = Group.where('id IN (?)', @my_groups_ids)
  end

  def about_com
    flash.clear
    @community = Community.find(params[:id])
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
  end

  def photos_com
    flash.clear
    @community = Community.find(params[:id])
    @albums = @community.albums
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
    @group_ids = current_user.user_groups.where("invitation = ? AND community_id = ?", Uc_enum::JOINED, @selected_community).collect(&:group_id)
    @albums << Album.where("albumable_id IN (?) AND albumable_type = ?", @group_ids, Objecttypeenum::GROUP)      
    @albums = @albums.sort_by(&:created_at).reverse
  end

 def members_com
    flash.clear
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
    @inv_pending_users = User.where(['id IN (?)' , @community.invited_uc.collect(&:user_id)])
    @ucs = @community.usercommunities.where('invitation = ?',Uc_enum::JOINED)
 end

 def groups_com
    flash.clear
    @community = Community.find(params[:id])
    @selected_community = @community
    @selected_community.req_pending_cnt = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)]).count
    @community.req_pending_cnt = @selected_community.req_pending_cnt
    @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", @selected_community.id, Uc_enum::JOINED ).collect(&:group_id).uniq
    @groups = Group.where('id IN (?)', @my_groups_ids)
    @other_groups = []
    if @my_groups_ids.blank?
      @other_groups = Group.where("community_id = ? AND privacy != ?", @selected_community.id, Privacyenum::PRIVATE )
    else
      @other_groups = Group.where("community_id = ? AND id NOT IN (?) AND privacy != ?", @selected_community.id, @my_groups_ids, Privacyenum::PRIVATE)
    end
    @group_ids = current_user.invited_groups.collect(&:group_id)
    @inv_groups = Group.where('id IN (?)', @group_ids)
 end

  def events_com
    flash.clear
    @community = Community.find(params[:id])
    @event = Event.new
      @event.starts_at = Time.zone.now.beginning_of_day
      @event.ends_at = Time.zone.now.end_of_day
      @event.address = @community.address
      @events = Event.where("starts_at > ? AND community_id = ?",Time.zone.now.beginning_of_day- 1.second, @community).order("starts_at ASC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @invited_events = []
      Eventdetail.where("user_id = ? AND status = ?", current_user.id, 'invited' ).find_each do |ed|
        @invited_events << ed.event
      end
      @period = 'up'
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

 def up_events
      @community = Community.find(params[:id])
      @events = Event.where("starts_at > ? AND community_id = ?",Time.zone.now.beginning_of_day - 1.second, @community).order("starts_at ASC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @period = 'up'
  
 end

 def prev_events
      @community = Community.find(params[:id])
      @events = Event.where("starts_at < ? AND community_id = ?",Time.zone.now.beginning_of_day, @community).order("starts_at DESC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @period = 'past'
 end

 def up_events_page
      @community = Community.find(params[:id])
      @events = Event.where("starts_at > ? AND community_id = ?",Time.zone.now.beginning_of_day - 1.second, @community).order("starts_at ASC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @period = 'up'
  
 end

 def prev_events_page
      @community = Community.find(params[:id])
      @events = Event.where("starts_at < ? AND community_id = ?",Time.zone.now.beginning_of_day, @community).order("starts_at DESC")
      @events = @events.paginate(page: params[:page], :per_page => 5)
      @period = 'past'
 end


 def create_event
       @event = current_user.events.build(params[:event])
      if @event.starts_at.nil?
        @event.starts_at = Time.zone.now.beginning_of_day
      end
      if @event.ends_at.nil?
        @event.ends_at = Time.zone.now.end_of_day
      end
      @event.community_id = active_community.id
      @event.save!  
      @activity = Activity.new
      @activity.event_id = @event.id
      @activity.title=@event.title
      @activity.description = "Main Event"
      @activity.is_admin = true
      @activity.save
      @event.activities << @activity

      unless params[:invite_everyone].nil?
        @ed_user = active_community.usercommunities.where("invitation = ?", Uc_enum::JOINED ).collect(&:user_id)
          @ed_user.each do |user_id|
            if user_id == current_user.id
                @event.eventdetails.create(user_id: current_user.id, is_admin: true, status: "yes")
            else
                @event.eventdetails.create(user_id: user_id, is_admin: false, status: "invited")
            end
          end
      end

      if @event.photo.nil?
        @photo = Photo.new
        @photo.remote_pic_url = "http://res.cloudinary.com/rashi/image/upload/v1378556932/events_medium_m4h4ww.jpg"
        @photo.save
        @event.photo = @photo 
      end

      if @event.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.content = "<span class='timestamp' style='font-size:15px;'> added event </span><strong><a href='/events/" + @event.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @event.title + " </a>.</strong>"
        @post.user_id = current_user.id
        @post.postable = @event
        @post.save
        @post.communities << active_community 
        @post.photos << @event.photo
      end

      respond_to do |format|
        if @event.save
          getNotifiableUsers(Objecttypeenum::EVENT, @event, nil, nil, Uc_enum::CREATED)
        #  format.html { redirect_to @event, format: 'js', :success => 'Event was successfully created.' }
          format.json { render :json => @event, :status => :created, :location => @event }
          format.js { redirect_to(:action => :show_event, :format => :js, :event_id => @event.id, id: active_community.id)} #redirect_to @event, format: :js, :success => 'Event was successfully created.' }
        else
          format.html { render :action => "index" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
 end

  def show_event
    @community = Community.find(params[:id])
    @event = Event.find(params[:event_id])
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
=begin
    @ad_users = []
    @event.eventdetails.where(" is_admin=?", true).find_each do |ed|
      @ad_users << ed.user
    end
    @inv_users = []
    @event.eventdetails.where(" is_admin=?", false).find_each do |ed|
      @inv_users << ed.user
    end
=end


  end

  def update_event
    @community = Community.find(params[:id])
    @event = Event.find(params[:event_id])
    @eds = @event.eventdetails
    @event.update_attributes(params[:event])
    render :action => :show_event
    
  end

  def delete_event
    @community = Community.find(params[:id])
    @event = Event.find(params[:event_id])
    @event.destroy
    redirect_to :action => "events_com"
  end

  def invite_event_guests_by_user
    @community = Community.find(params[:id])
    @event = Event.find(params[:event][:id])
    @eds = @event.eventdetails
    @ed_user = @eds.collect(&:user_id)
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
      unless params[:invite_everyone].nil?
        @com_user = active_community.usercommunities.where("invitation = ?", Uc_enum::JOINED ).collect(&:user_id)
        @ed_user_add = @com_user - @ed_user
        @ed_user = @ed_user + @ed_user_add
          @ed_user_add.each do |user_id|
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

  def invite_event_guests_by_email
   @community = Community.find(params[:id])
   @event = Event.find(params[:event][:id])
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

 def add_event_moderators
    @event = Event.find(params[:event][:id])
    @event.eventdetails.where("user_id IN (?)", params[:user_all_ids]).update_all(is_admin: false)
    @event.eventdetails.where("user_id IN (?)", params[:user_ids]).update_all(is_admin: true)
    @users = User.where("id IN (?)", params[:user_ids])
    @community = Community.find(params[:id])
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)
      @users.each do |usr|
      #  getNotifiableUsers(Objecttypeenum::COMUNITY, @community, Objecttypeenum::USER, usr, Uc_enum::ADD_MODERATOR)
      end
 end

 def get_activity
    @community = Community.find(params[:id])
    @activity = Activity.find(params[:activity_id])
    @event = Event.find(params[:event_id])
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)
 end

  def create_activity
    @event = Event.find(params[:activity][:event_id])
    @activity = @event.activities.build(params[:activity])
    @activity.save
        @ad = Activitydetail.new
        @ad.is_admin=true
        @ad.user = current_user
        @activity.activitydetails << @ad
      if @activity.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.content = "<span class='timestamp' style='font-size:15px;'> added an activity </span><strong><a href='/activities/" + @activity.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @activity.title + " </a></strong><span class='timestamp' style='font-size:15px;'> to the event </span><strong><a href='/events/" + @event.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @event.title + " </a>.</strong>"
        @post.user_id = current_user.id
        @post.postable = @activity
        @post.save
        @post.communities << active_community 
        @post.photos << @event.photo
      end
    getNotifiableUsers(Objecttypeenum::ACTIVITY, @activity, nil, nil, Uc_enum::CREATED)
    @activities = @event.activities
    @community = Community.find(params[:id])
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)
    render :action => :get_activity
  end


  def update_activity
    @community = Community.find(params[:id])
    @event = Event.find(params[:activity][:event_id])
    @activity = Activity.find(params[:activity][:id])
    @activity.update_attributes(params[:activity])
    
  end

  def delete_activity
    @activity = Activity.find(params[:activity_id])
    @activity.destroy
    @event = Event.find(@activity.event_id)
    @community = Community.find(params[:id])
    @eds = @event.eventdetails
    @ad_users = @event.eventdetails.where(" is_admin=?", true)
    @inv_users = @event.eventdetails.where(" is_admin=?", false)

     render :action => :show_event
  end

  def add_activity_guests
    @activity = Activity.find(params[:activity][:id])
    @event = Event.find(params[:event_id])
    @ed_user = @event.eventdetails.pluck(:user_id)
    @ad_user = @activity.activitydetails.pluck(:user_id)
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
    @community = Community.find(params[:id])
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)
  end

  def unjoin_activity
    @activity = Activity.find(params[:activity_id])
    @activity.activitydetails.find_by_user_id(params[:user_id]).destroy
    respond_to do |format|
      format.all { redirect_to :action => "get_activity", :event_id => params[:event_id], id: params[:id], :activity_id => params[:activity_id] }
   end
  end

  def add_activity_moderators
    @event = Event.find(params[:event_id])
    @activity = Activity.find(params[:activity][:id])
    @activity.activitydetails.where("user_id IN (?)", params[:user_all_ids]).update_all(is_admin: false)
    @activity.activitydetails.where("user_id IN (?)", params[:user_ids]).update_all(is_admin: true)
    @community = Community.find(params[:id])
    @eds = @event.eventdetails
    @ads = @activity.activitydetails
    @ad_users = @activity.activitydetails.where(" is_admin=?", true)
    @inv_users = @activity.activitydetails.where(" is_admin=?", false)

  end

  def event_invitation
    @event = Event.find(params[:event_id])
    @ed_user = @event.eventdetails.find_by_user_id(current_user.id)
    @ed_user.status = params[:status]
    @ed_user.save
    respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
    end
  end

  def search_event_guests
    @event = Event.find(params[:event_id])
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


  def event_posts
    if params[:activity_id].nil?
      @event = Event.find(params[:event_id])
      @community = Community.find(params[:id])
      @activity = @event.activities.where(is_admin: true).first
      @post = Post.new
      @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
    else
      @event = Event.find(params[:event_id])
      @activity = Activity.find(params[:activity_id])
      @community = Community.find(params[:id])
      @post = Post.new
      @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
    end
  end

  def event_posts_page
      @event = Event.find(params[:event_id])
      @activity = Activity.find(params[:activity_id])
      @community = Community.find(params[:id])
      @post = Post.new
      if @activity.is_admin
        @posts = @event.posts.paginate(:page => params[:page], :per_page => 4)
      else
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => 4)
      end 
  end

  def create_activity_post
      @community = Community.find(params[:id])
      @event = Event.find(params[:event_id])
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
      getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::ACTIVITY, @activity, Uc_enum::CREATED)
      @post_type = 'activity'
      respond_to do |format|
        format.html { redirect_to @activity, format: 'js' }
         format.js {  }
      end
  end

  def event_members
    unless params[:activity_id].nil?
      @event = Event.find(params[:event_id])
      @activity = Activity.find(params[:activity_id])
      @community = Community.find(params[:id])
      @eds = @event.eventdetails
      @ads = @activity.activitydetails
      @ad_users = @activity.activitydetails.where(" is_admin=?", true)
      @inv_users = @activity.activitydetails.where(" is_admin=?", false)
    else
      @event = Event.find(params[:event_id])
      @community = Community.find(params[:id])
      @eds = @event.eventdetails
      @ad_users = @event.eventdetails.where(" is_admin=?", true)
      @inv_users = @event.eventdetails.where(" is_admin=?", false)
    end
  end

  def event_photos
  end

 def create_album
     @community = Community.find(params[:id])
     @album = current_user.albums.build(params[:album])
        @album.save
        @photos = params[:photos][:pic]
        @photos.each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @album.photos << @photo
          end
        @album.save
        @community.albums << @album
        @community.save
        @albums = @community.albums
        @pic_arr = []
        @album.photos.each do |photo|
          @pic_arr << File.basename( photo.pic_url, ".*" )
        end
        @str = @album.title+"_"+@album.id.to_s
        @str = @str.downcase.tr(" ", "_")
            Cloudinary::Uploader.add_tag(@str, @pic_arr)
            if params[:downloadable]
                  @cld = Cloudinary::Uploader.multi(@str, :format => 'zip')
                  @album.downloadlink = @cld["url"]
                  @album.save
            end
      if @album.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.content = "<span class='timestamp' style='font-size:15px;'>added " + view_context.pluralize(@album.photos.count, "photo") + " to the album </span><strong><a href='/albums/" + @album.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @album.title + " </a>.</strong>"
        @post.user_id = current_user.id
        @post.postable = @album
        @post.save
        @post.communities << active_community 
        @album.photos.each do |photo|
          @post.photos << photo
        end
      end

    @group_ids = current_user.user_groups.where("invitation = ? AND community_id = ?", Uc_enum::JOINED, @community).collect(&:group_id)
    @albums << Album.where("albumable_id IN (?) AND albumable_type = ?", @group_ids, Objecttypeenum::GROUP)      
    @albums = @albums.sort_by(&:created_at).reverse

        body_text = "The Album '" + @album.title + "' was created by "+ current_user.name
        href = "/albums/"+ @album.id.to_s

        #getNotifiableUsers(Objecttypeenum::ALBUM, @album, @album.albumable_type, @album.albumable_id, Uc_enum::CREATED)

    
        flash[:success] = "Album: " + @album.title + " created!"
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end


  def invites_requests
    @group_ids = current_user.invited_groups.collect(&:group_id)
    @inv_groups = Group.where('id IN (?)', @group_ids)
    @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
    
  end

  def show_group
    @group = Group.find(params[:grp_id])
    @inv_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,false).collect(&:user_id)])
    @ad_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,true).collect(&:user_id)])
    @is_admin = @ad_users.include? current_user
    @ucs = @group.user_groups.where("group_id = ? AND invitation = ?",params[:grp_id], Uc_enum::JOINED)
    @community = Community.find(params[:id])
  end

  def group_posts
     @community = Community.find(params[:id])
     @group = Group.find(params[:grp_id])
     @post = Post.new
     @posts = @group.posts.paginate(page: params[:page], :per_page => 4)
  end


  def group_members
    @group = Group.find(params[:grp_id])
    @inv_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,false).collect(&:user_id)])
    @ad_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,true).collect(&:user_id)])
    @is_admin = @ad_users.include? current_user
    @ucs = @group.user_groups.where("group_id = ? AND invitation = ?",params[:grp_id], Uc_enum::JOINED)
    @community = Community.find(params[:id])
  end

  def group_photos
    @group = Group.find(params[:grp_id])
    @album = Album.new
    @albums = @group.albums
    @community = Community.find(params[:id])
  end

  def destroy
    Community.find(params[:id]).destroy
     if active_community.id.to_s == params[:id]
        @smarthood_com_id = Community.where(name: 'Smarthood')[0].id
        @usercommunity = @user.usercommunities.find_by_community_id(@smarthood_com_id)
        @usercommunity.status="active"
        @usercommunity.save
     end
  end

def cu_list
  
end

end
