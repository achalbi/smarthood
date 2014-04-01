class PostsController < ApplicationController
  include ActivitynotificationsHelper, UsersHelper

  before_filter :signed_in_user, only: [:create, :destroy]
 # before_filter :correct_user,   only: :destroy

  def index
    @post = Post.new
    @user_groups = current_user.user_groups.all
  end

  def create
    case params[:type]
    when "activity"
      @activity = Activity.find(params[:activity])
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
      @activityposts = Activitypost.wehere("activity_id = ? ", @activity)
      @posts = @activityposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq 
      getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::ACTIVITY, @activity, Uc_enum::CREATED)
      @post =Post.new
      @post_type = 'activity'
      respond_to do |format|
       format.html { redirect_to @activity, format: 'js' }
       format.js {  }
     end
   when "group"
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(params[:post])
    @post.user = current_user
    @post.save(:validate => false)
    unless params[:photo].nil?
      @post.photos << current_user.photos.build(params[:photo])
      @post.save(:validate => false)
    end
    @post.communities << active_community 
    @group.posts << @post
    @groupposts = Grouppost.where('group_id = ?', @group)
    @posts = @groupposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq 
    getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::GROUP, @group, Uc_enum::CREATED)
    @post =Post.new
    @post_type = 'group'
    respond_to do |format|
     format.html { }
     format.js {  }
   end
 when "groups"
      if params[:grp_ids].nil?
        #flash[:error] = "Please select Group"
        @post = Post.new
        @groups = Group.where('id IN (?)', current_user.user_groups.collect(&:group_id))
      else
        @post_groups = Group.where('id IN (?)',params[:grp_ids])
        @post = current_user.posts.build(params[:post])
        @post.user = current_user
        @post.save(:validate => false)
        unless params[:photo].nil?
          @post.photos << current_user.photos.build(params[:photo])
          @post.save(:validate => false)
        end
        @post_groups.each do |group|
          @post.groups << group
        end  
        @post.communities << active_community 
        getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::GROUPS, @post.groups, Uc_enum::CREATED)
        @post = Post.new
        @group_ids = current_user.user_groups.collect(&:group_id)
        @groups = Group.where('id IN (?)', @group_ids)
        @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
        @posts = @groupposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq   
          # @post.save
           #  flash[:success] = "Post created!"
        @post_type = 'groups'
      end
       when "communities"
        if params[:cu_ids].nil?
          @post = current_user.posts.build(params[:post])
          @communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)]) 
          @post.user = current_user
          @post.save(:validate => false)
          unless params[:photo].nil?
            @post.photos << current_user.photos.build(params[:photo])
            @post.save(:validate => false)
          end
          @post.communities << active_community 

        else
          @post_cus = Community.where('id IN (?)',params[:cu_ids])
          @post = current_user.posts.build(params[:post])
          @post.user = current_user
          @post.save(:validate => false)
          unless params[:photo].nil?
            @post.photos << current_user.photos.build(params[:photo])
            @post.save(:validate => false)
          end
          @post_cus.each do |cu|
            @post.communities << cu
          end   
        end
        getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::COMUNITY, @post.communities, Uc_enum::CREATED)
        @post = Post.new
        @cu_ids = current_user.communities.collect(&:id)
        @communities = Community.where('id IN (?)', @cu_ids)
        @communityposts = Communitypost.where('community_id IN (?)', @cu_ids)
        @posts = @communityposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq   
        @post_type = 'communities'
        # @post.save
         #  flash[:success] = "Post created!"
     when "community"
          @post = current_user.posts.build(params[:post])
          @post.user = current_user
          @post.save(:validate => false)
          @post_groups = Group.where('id IN (?)',params[:grp_ids])
          unless params[:photo].nil?
            @post.photos << current_user.photos.build(params[:photo])
            @post.save(:validate => false)
          end
          @post_groups.each do |group|
            @post.groups << group
          end  
          @community = Community.find(params[:id])
          @selected_community = @community
          @post.communities << @community 
          @selected_comm  = []
          @selected_comm << @community
          @post = Post.new
          @communityposts = Communitypost.where('community_id = (?)', @community)
          @posts = @communityposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq
          @my_groups_ids = current_user.user_groups.where("community_id = ? AND invitation = ? ", params[:id], Uc_enum::JOINED ).collect(&:group_id).uniq
          @groups = Group.where('id IN (?)', @my_groups_ids)
          @post_type = 'community'
          getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::COMUNITY, @post.communities, Uc_enum::CREATED)  
       else
       end
     end

  def destroy
      @post = Post.find(params[:id])
      @id = @post.id 
      @post.destroy
    respond_to do |format|
     format.html { }#redirect_to @activity, format: 'js' }
     format.js { }
   end
 end

 def show
   @post = Post.find(params[:id])
   @posts = Post.where("id = ? ", params[:id])
 end

 def cus_post_paginate
  @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
  @comm_id << active_community.id
  @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) 
  @selected_comm = []
  @selected_comm << active_community
  @post = Post.new
   @cu_ids = current_user.joined_uc.collect(&:community_id)
      @communities = Community.where('id IN (?) ', @cu_ids)
      @post_ids = []
      @communitypost_ids = Communitypost.where('community_id IN (?)', @cu_ids).collect(&:post_id)
      @post_ids = @communitypost_ids
      @group_ids = current_user.user_groups.where("invitation = ?", Uc_enum::JOINED).collect(&:group_id)
      unless @group_ids.blank?
        @grouppost_ids = Grouppost.where('group_id IN (?)', @group_ids).collect(&:post_id)
        @post_ids = @post_ids + @group_ids
      end
      @posts = Post.where('id IN (?)', @post_ids).paginate(page: params[:page], :per_page => 4)
  @post_type = 'communities'
end

def userLike
  @post = Post.find(params[:post_id])
  @userlike = current_user.userlikes.new
  @userlike.likeable = @post
  @userlike.save

end

def userUnlike
  @post = Post.find(params[:post_id]) 
  @userlike = Userlike.where(likeable_id: params[:post_id], likeable_type: "Post", user_id: current_user.id)
  @userlike[0].destroy
end

def share
  @post = Post.find(params[:post][:id])
  @newPost = Post.new
  @newPost.attributes = @post.attributes.except("id", "created_at", "updated_at")
  @newPost.content = params[:post][:content]
  @newPost.user_id = current_user.id
  @newPost.save
  @post_cus = Community.where('id IN (?)',params[:community_id])
  @post_cus.each do |cu|
    @newPost.communities << cu
  end
  unless @post.photos.blank?
   @photo = Photo.new
   @photo.remote_pic_url = @post.photos[0].pic_url
   @photo.post_id = @newPost.id
   @photo.save
 end
 getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::COMUNITY, @post.communities, Uc_enum::SHARED)
end

private

def correct_user
  begin
    @post = current_user.posts.find(params[:id])
  rescue => e
  puts e.to_s
    redirect_to root_url
  end
end




end