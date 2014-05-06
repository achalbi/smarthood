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
  @group.community_id = params[:community_id]
  if @group.save
    unless params[:group][:user_tokens].nil?
      @user_ids = params[:group][:user_tokens].split(",")
      @user_ids.each do |id|
        @usergroup = UserGroup.new 
        @usergroup.group_id = @group.id
        @usergroup.user_id = id
        @usergroup.is_admin = false
        @usergroup.invitation = Uc_enum::JOINED
        @usergroup.community_id = params[:community_id]
        @usergroup.save
      end
    end
   flash[:success] = "Group:" + @group.name + " created!"
    @group.follow!(current_user, @group.id, Uc_enum::JOINED, true,  params[:community_id])
    #UserGroup.where("user_id = ? AND group_id = ?",current_user.id, @group.id).update_all(is_admin: true, invitation: Uc_enum::JOINED)
      # redirect_to :action => :index
      getNotifiableUsers(Objecttypeenum::GROUP, @group, nil, nil, Uc_enum::CREATED)
    else
    	flash[:error] = "Group not created!"
       # redirect_to :action => :index
     end 
     if params[:community_id].nil?
         respond_to do |format|
           format.html { redirect_to :action => :index   }
           format.js { redirect_to @group   }
         end
     else
          respond_to do |format|
           format.html { }
           format.js { redirect_to :controller => 'communities', :action => 'show_group', :grp_id => @group.id, id: params[:comm_id] }
         end
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
    @community = active_community
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
  @group = Group.find(params[:id])
  @group.user_groups.update_all({:is_admin => true}, {:user_id => params[:user_ids]})
  @group.user_groups.update_all({:is_admin => false}, {:user_id => params[:user_all_ids]-params[:user_ids] })
   redirect_to :controller => 'communities', :action => 'show_group', :grp_id => @group.id, id: params[:comm_id]
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
       @usergroup.invitation = Uc_enum::JOINED
       @usergroup.community_id = params[:comm_id]
       @usergroup.save
     else   #if (@usergroup.invitation==Uc_enum::REQUESTED || @usergroup.invitation==Uc_enum::MODERATOR_DECLINED)
       @usergroup.invitation = Uc_enum::JOINED
    # elsif @usergroup.invitation == Uc_enum::USER_DECLINED
    #   @usergroup.invitation = Uc_enum::INVITED
    #   getNotifiableUsers(Objecttypeenum::GROUP, @group, Objecttypeenum::USER, @user_ids, Uc_enum::INVITED)
     end
     getNotifiableUsers(Objecttypeenum::GROUP, @group, Objecttypeenum::USER, @user_ids, Uc_enum::JOINED)
     @usergroup.save

   end
 end 
 unless params[:comm_id].nil?
   redirect_to :controller => 'communities', :action => 'show_group', :grp_id => @group.id, id: params[:comm_id]
 end
end

def search_app_user
  @community = Community.find(params[:comm_id])
  @group_users = []
  unless params[:id].nil?
    @group = Group.find(params[:id])
    @group_users = @group.user_groups.where('invitation = ?',Uc_enum::JOINED).collect(&:user_id).uniq
  end
  @users = User.where("id IN (?)", @community.usercommunities.where('invitation = ?',Uc_enum::JOINED).collect(&:user_id).uniq - @group_users)
  @users = @users.where("LOWER(users.name) like LOWER(?) AND users.id != ?", "%#{params[:q]}%", current_user.id)
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
        @post.title = "<span class='timestamp' style='font-size:15px;'>added " + view_context.pluralize(@album.photos.count, "photo") + " to the album </span><strong><a href='/albums/" + @album.id.to_s + "' style='font-size:15px;word-wrap:break-word;' data-remote='true' > " + @album.title + " </a>.</strong>"
        @post.content = ""
        @post.user_id = current_user.id
        @post.postable = @album
        @post.save
        @post.communities << active_community
        @post.groups << @group 
        @album.photos.each do |photo|
          @post.photos << photo
        end
      end
        body_text = "The Album '" + @album.title + "' was created by "+ current_user.name
        href = "/albums/"+ @album.id.to_s

        #getNotifiableUsers(Objecttypeenum::ALBUM, @album, @album.albumable_type, @album.albumable_id, Uc_enum::CREATED)
    
        flash[:success] = "Album: " + @album.title + " created!"
      @album_old = @album
      @album = Album.new
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
        respond_to do |format|
           format.html { }
           format.js { redirect_to :controller => 'communities', :action => 'show_group', :grp_id => @group.id, id: @group.community_id }
         end
  end

def acceptrequest
 @usergroup = UserGroup.where('group_id=? and user_id=?',params[:id],params[:user_id])[0]
 @usergroup.invitation = Uc_enum::JOINED
 @usergroup.save
 @groups = Group.where(['id  IN (?)', current_user.user_groups.collect(&:group_id)]) 
 @group_ids = current_user.invited_groups.collect(&:group_id)
 @inv_groups = Group.where('id IN (?)', @group_ids)
 @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
 @inv_req_grps = current_user.invited_groups.collect(&:group_id)
end

def declinerequest
 @usergroup = UserGroup.where('group_id=? and user_id=?',params[:id],params[:user_id])[0]
 @usergroup.invitation = Uc_enum::USER_DECLINED
 @usergroup.save
 @group_ids = current_user.invited_groups.collect(&:group_id)
 @inv_groups = Group.where('id IN (?)', @group_ids)
 @inv_req_cu = Community.where(['id IN (?)' , current_user.communities.where('invitation = ?',Uc_enum::INVITED).collect(&:id)])
 @inv_req_grps = current_user.invited_groups.collect(&:group_id)
end

def unjoin_grp
  @usergroup
  if params[:user_id].nil?
    @usergroup = current_user.user_groups.find_by_group_id(params[:id])
    @usergroup.invitation = Uc_enum::UNJOINED
    @usergroup.save
  else
    @user = User.find(params[:user_id])
    @usergroup = @user.user_groups.find_by_group_id(params[:id])
    @usergroup.invitation = Uc_enum::UNJOINED
    @usergroup.save
    redirect_to :controller => 'communities', :action => 'show_group', :grp_id => params[:id], id: params[:comm_id]

  end
end

def join_grp
  @group = Group.find(params[:id])
  @group.follow!(current_user, params[:id], Uc_enum::JOINED, false, params[:comm_id])
  redirect_to :controller => 'communities', :action => 'show_group', :grp_id => params[:id], id: params[:comm_id]

end

def destroy
  Group.find(params[:id]).destroy
end


private  
def sort_column  
  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
end  

def sort_direction  
 %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"   
end  

end
