class CommunitiesController < ApplicationController
  include PhotosHelper
  before_filter :signed_in_user, only: [:create, :destroy]

  def new
  	@community = Community.new
  end

  def index
  	@community = Community.new
    @selected_community = nil
    @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
    unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
      @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
      @my_communities = Community.where(['id IN (?) and id!=?', current_user.communities.collect(&:id),@selected_community.id]) 
    end
    @public_communities = Community.where(['id  NOT IN (?)' , current_user.communities.collect(&:id)]) 

    @requested_users = nil
    unless @selected_community.nil?
      @ad_eds = @selected_community.usercommunities.where(is_admin: true )
      @non_ad_eds = @selected_community.usercommunities.where(is_admin: false)
      @users = @non_ad_eds.pluck(:user_id)
      @admin_users = @ad_eds.pluck(:user_id)
      @inv_users = User.where(['id IN (?)', @users])
      @ad_users = User.where(['id IN (?)', @admin_users])
      @requested_users = nil
      @ucs = @selected_community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
      if @ucs.count > 0
        @requested_users = User.where(['id IN (?)' , @selected_community.requested_uc.collect(&:user_id)])
      end  
    end
    @ucs_all = current_user.usercommunities.where("is_admin=?", true )
    @my_mod_communities = Community.where(['id IN (?)', @ucs_all.collect(&:community_id)]) 
    @requested_users_all = 0
    @my_mod_communities.each do |community|
      @requested_users_all += User.where(['id IN (?)' , community.requested_uc.collect(&:user_id)]).count
    end
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
      @usercommunity.invitation="joined"
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
  @ad_eds = @community.usercommunities.where(is_admin: true )
  @non_ad_eds = @community.usercommunities.where(is_admin: false)
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
if @uc_count < 1
  render js: %(window.location.href='#{root_path}')
end
end

def sendrequest
 @usercommunity = Usercommunity.new 
 @usercommunity.community_id = params[:id]
 @usercommunity.user_id = current_user.id
 @usercommunity.invitation = "requested"
 @usercommunity.is_admin = false
 @usercommunity.status=""
 @usercommunity.save

end

def acceptrequest
 @usercommunity = Usercommunity.where(['community_id=? and user_id=?',params[:id],params[:user_id]])[0]
 @usercommunity.invitation = "joined"
 @usercommunity.save
 @community = Community.find(params[:id])
 @ad_eds = @community.usercommunities.where(is_admin: true )
 @non_ad_eds = @community.usercommunities.where(is_admin: false)
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

def declinerequest
 @usercommunity = Usercommunity.where(['community_id=? and user_id=?',params[:id],params[:user_id]])[0]
 @usercommunity.invitation = "decline"
 @usercommunity.save
 @community = Community.find(params[:id])
 @ad_eds = @community.usercommunities.where(is_admin: true )
 @non_ad_eds = @community.usercommunities.where(is_admin: false)
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
 @usercommunity = Usercommunity.new 
 @usercommunity.community_id = params[:id]
 @usercommunity.user_id = current_user.id
 @usercommunity.invitation = "joined"
 @usercommunity.is_admin = false
 @usercommunity.status=""
 @usercommunity.save
end

def show
  @community = Community.find(params[:id])
  @user = current_user
  @users = @community.users
  @ad_eds = @community.usercommunities.where(is_admin: true )
  @non_ad_eds = @community.usercommunities.where(is_admin: false)
  @users = @non_ad_eds.pluck(:user_id)
  @admin_users = @ad_eds.pluck(:user_id)
  @inv_users = User.where(['id IN (?)', @users])
  @ad_users = User.where(['id IN (?)', @admin_users])
  @requested_users = nil
  @ucs = @community.usercommunities.where("user_id = ?  AND is_admin=?",current_user.id, true )
  if @ucs.count > 0
    @requested_users = User.where(['id IN (?)' , @community.requested_uc.collect(&:user_id)])
  end
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
  @ad_eds = @community.usercommunities.where(is_admin: true )
  @non_ad_eds = @community.usercommunities.where(is_admin: false)
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

def joined_com
  @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
  unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
    @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
    @ucs = current_user.usercommunities.where("is_admin=?", true )
    @communities = Community.where(['id IN (?)', @ucs.collect(&:community_id)]) 
    @communities << @selected_community
    @my_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @communities.collect(&:id)]) 
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
    @public_communities = Community.where(["id  NOT IN (?) AND privacy ='public'" , current_user.joined_uc.collect(&:community_id)])  
  else
    @public_communities = Community.where("privacy ='public'") 
  end 
  @communities = @public_communities  
end

def private_com
  @private_communities = nil
  if current_user.joined_uc.collect(&:community_id).count > 0 
    @private_communities = Community.where(["id  NOT IN (?) AND privacy = 'private'" , current_user.joined_uc.collect(&:community_id)])   
  else
    @private_communities = Community.where("privacy ='private'") 
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

end
