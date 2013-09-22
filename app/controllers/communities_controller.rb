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

    @ad_eds = @selected_community.usercommunities.where(is_admin: true )
    @non_ad_eds = @selected_community.usercommunities.where(is_admin: false)
    @users = @non_ad_eds.pluck(:user_id)
    @admin_users = @ad_eds.pluck(:user_id)
    @inv_users = User.where(['id IN (?)', @users])
    @ad_users = User.where(['id IN (?)', @admin_users])


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
      flash[:success] = "community created!"
      @usercommunity = @community.follow!(current_user, @community.id)
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
    	flash[:error] = "community not created!"
    end 
      respond_to do |format|
         format.html { redirect_to :action => :index   }
         format.js { }
      end

  end

  def setactive
   @usercommunity = Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0]
   @usercommunity.status=""
   @usercommunity.save
   @usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',params[:id],current_user.id])[0]
   @usercommunitySel.status="active"
   @usercommunitySel.save
  
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
  end

  def joined_com
    @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
    unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
      @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
      @my_communities = Community.where(['id IN (?) and id!=?', current_user.communities.collect(&:id),@selected_community.id]) 
    end 
    @communities = @my_communities  
  end

  def public_com
     @public_communities = Community.where(['id  NOT IN (?) AND privacy = "open"' , current_user.communities.collect(&:id)])   
     @communities = @public_communities  
  end

  def private_com
     @private_communities = Community.where(['id  NOT IN (?) AND privacy = "closed"' , current_user.communities.collect(&:id)])   
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
