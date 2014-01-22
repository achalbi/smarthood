class PostsController < ApplicationController
  include ActivitynotificationsHelper, UsersHelper

  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

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
      @posts = @activity.posts.order("id DESC").all
      getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::ACTIVITY, @activity, Uc_enum::CREATED)
      @post =Post.new
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
    @posts = @group.posts.order("id DESC").all
    getNotifiableUsers(Objecttypeenum::POST, @post, Objecttypeenum::GROUP, @group, Uc_enum::CREATED)
    @post =Post.new
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
      @posts = @groupposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq   
        # @post.save
         #  flash[:success] = "Post created!"
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
      @posts = @communityposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq   
        # @post.save
         #  flash[:success] = "Post created!"
   else
   end
   end

   def destroy
    @post = Post.find(params[:id])
    @id = @post.id 
    @post.destroy
    respond_to do |format|
     format.html { redirect_to @activity, format: 'js' }
     format.js { }
   end
 end

 def show
   @post = Post.find(params[:id])
   @posts = Post.where("id = ? ", params[:id])
 end

 def cus_post_paginate
    @post = Post.new
      @cu_ids = current_user.communities.collect(&:id)
      @communities = Community.where('id IN (?)', @cu_ids)
      @communityposts = Communitypost.where('community_id IN (?)', @cu_ids)
      @posts = @communityposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq
 end

 private

 def correct_user
  @post = current_user.posts.find(params[:id])
rescue
  redirect_to root_url
end



end