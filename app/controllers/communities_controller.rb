class CommunitiesController < ApplicationController
include PhotosHelper
before_filter :signed_in_user, only: [:create, :destroy]

  def new
  	@community = Community.new
  end

  def index
  	@communities = Community.new
    @selected_community = nil
    @my_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
    unless Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
      @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
      @my_communities = Community.where(['id IN (?) and id!=?', current_user.communities.collect(&:id),@selected_community.id]) 
    end
     @public_communities = Community.where(['id  NOT IN (?)' , current_user.communities.collect(&:id)]) 

  end

  def create
  	@community = current_user.communities.build(params[:community])
    @community.user = current_user
    if @community.photo.nil?
     @community.photo = defaultPhoto('new_group')
    end
    if @community.save
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
     # respond_to do |format|
     #    format.html { redirect_to :action => :index   }
     #    format.js {redirect_to :action => :index, format: 'js'  }
     # end
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
      respond_to do |format|
         format.html {  }
         format.js {render  :locals => { :community => @community, :user => @user }  }
      end
    end

end
