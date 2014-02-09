class GroupsController < ApplicationController
  include PhotosHelper, GroupsHelper, UsersHelper, ActivitynotificationsHelper
  before_filter :signed_in_user, only: [:create, :destroy]

  def new
  	@group = Group.new
  end
  def index
    @group = Group.new
   # @groups = Group.where(:id => current_user.user_groups.collect(&:group_id)) 
   #@groups = active_community_user_groups
   @my_groups = Group.where('id IN (?)', current_user.user_groups.collect(&:group_id))
   @community = active_community 
 end

 def create
  @group = current_user.groups.build(params[:group])
  @group.User = current_user
  if @group.photo.nil?
    @photo = Photo.new
    @photo.remote_pic_url = "http://res.cloudinary.com/rashi/image/upload/v1381586772/Group_td3iuo.png"
    @photo.save
    @group.photo = @photo 
  end
  @group.community_id = active_community.id
  if @group.save
    unless params[:group][:user_tokens].nil?
      @user_ids = params[:group][:user_tokens].split(",")
      @user_ids.each do |id|
        @usergroup = UserGroup.new 
        @usergroup.group_id = @group.id
        @usergroup.user_id = id
        @usergroup.is_admin = false
        @usergroup.invitation = Uc_enum::INVITED
        @usergroup.community_id = params[:community_id]
        @usergroup.save
      end
    end
   # flash[:success] = "Group created!"
    @group.follow!(current_user, @group.id, Uc_enum::JOINED, true,  params[:community_id])
    #UserGroup.where("user_id = ? AND group_id = ?",current_user.id, @group.id).update_all(is_admin: true, invitation: Uc_enum::JOINED)
      # redirect_to :action => :index
      getNotifiableUsers(Objecttypeenum::GROUP, @group, nil, nil, Uc_enum::CREATED)
    else
    	flash[:error] = "Group not created!"
       # redirect_to :action => :index
     end 
     respond_to do |format|
       format.html { redirect_to :action => :index   }
       format.js 
     end
   end

 def show
    @group = Group.find(params[:id])
    @post = Post.new
    @posts = @group.posts.paginate(page: params[:page], :per_page => 8)
    @user = current_user
    @users = @group.users
    @album = Album.new
    @inv_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,false).collect(&:user_id)])
    @ad_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,true).collect(&:user_id)])
    @is_admin = @ad_users.include? current_user
    @ucs = @group.user_groups.where("user_id = ?  AND is_admin=?",current_user.id, true )
    respond_to do |format|
     format.html {  }
     format.js {render  :locals => { :group => @group, :posts => @posts, :user => @user }  }
    end
 end

 def group_post
    @group_ids = current_user.user_groups.collect(&:group_id)
    @groups = Group.where('id IN (?)', @group_ids)
    @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
    @posts = @groupposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq
    @post = Post.new
    
 end

 def followers
  @title = "Followers"
  @group = Group.find(params[:id])
  @users = @group.users.paginate(page: params[:page], :per_page => 8)
  render 'show_follow'
end

def add_moderators

end

def groups_post_paginate
    @group_ids = current_user.user_groups.collect(&:group_id)
    @groups = Group.where('id IN (?)', @group_ids)
    @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
    @posts = @groupposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq
    @post = Post.new
end


def my
 @groups = Group.where(['id  IN (?)', current_user.user_groups.collect(&:group_id)]) 
end

def public
 @groups = Group.where(['id  NOT IN (?) AND privacy  = ?' , current_user.user_groups.collect(&:group_id), false]) 
end

def invite_app_user
  unless params[:group][:user_tokens].nil?
    @user_ids = params[:group][:user_tokens].split(",")
    @user_ids.each do |id|
      @usergroup = UserGroup.where('group_id=? and user_id=?',params[:id],id)[0]
      @group = Group.find(params[:id])
      if @usergroup.blank?
       @usergroup = UserGroup.new 
       @usergroup.group_id = params[:id]
       @usergroup.user_id = id
       @usergroup.is_admin = false
       @usergroup.invitation = Uc_enum::INVITED
       @usergroup.save
       getNotifiableUsers(Objecttypeenum::GROUP, @group, Objecttypeenum::USER, @user_ids, Uc_enum::INVITED)
     elsif (@usergroup.invitation==Uc_enum::REQUESTED || @usergroup.invitation==Uc_enum::MODERATOR_DECLINED)
       @usergroup.invitation = Uc_enum::JOINED
     elsif @usergroup.invitation == Uc_enum::USER_DECLINED
       @usergroup.invitation = Uc_enum::INVITED
       getNotifiableUsers(Objecttypeenum::GROUP, @group, Objecttypeenum::USER, @user_ids, Uc_enum::INVITED)
     end
     @usergroup.save

   end
 end 
end

def search_app_user
  @users = User.where("id IN (?)", active_community.usercommunities.collect(&:user_id))
  @users = @users.where("users.name like ? AND users.id != ?", "%#{params[:q]}%", current_user.id)
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

def create_album
     @group = Group.find(params[:id])
    @album = current_user.albums.build(params[:album])
        @album.save
        @photos = params[:photos][:pic]
        @photos.each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @album.photos << @photo
          end
        @album.save
        @group.albums << @album
        @group.save
        @albums = @group.albums
        @album_old = @album
        getNotifiableUsers(Objecttypeenum::ALBUM, @album, nil, nil, Uc_enum::CREATED)
        @album = Album.new
          flash[:success] = "Album created"
      @share = Share.new
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end

  def post_paginate
      @group = Group.find(params[:id])
      @posts = @group.posts.paginate(:page => params[:page], :per_page => 4)
  end

  def update
    @group = Group.find(params[:id])
    @group.update_attributes(params[:group])
    getNotifiableUsers(Objecttypeenum::GROUP, @group, nil, nil, Uc_enum::UPDATED)
  end

def acceptrequest
 @usergroup = UserGroup.where('group_id=? and user_id=?',params[:id],params[:user_id])[0]
 @usergroup.invitation = Uc_enum::JOINED
 @usergroup.save
 @groups = Group.where(['id  IN (?)', current_user.user_groups.collect(&:group_id)]) 
end

def declinerequest
 @usergroup = UserGroup.where('group_id=? and user_id=?',params[:id],params[:user_id])[0]
 @usergroup.invitation = Uc_enum::USER_DECLINED
 @usergroup.save
end

private  
def sort_column  
  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
end  

def sort_direction  
 %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"   
end  

end
