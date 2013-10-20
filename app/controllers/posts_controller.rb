class PostsController < ApplicationController
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
      @activity.posts << @post
      @post.activityposts[0].update_attributes(:event_id => @activity.event_id)
      @posts = @activity.posts.order("id DESC").all
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
    @group.posts << @post
    @posts = @group.posts.order("id DESC").all
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
    @post = Post.new
    @group_ids = current_user.user_groups.collect(&:group_id)
    @groups = Group.where('id IN (?)', @group_ids)
    @groupposts = Grouppost.where('group_id IN (?)', @group_ids)
    @posts = @groupposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq   
      # @post.save
       #  flash[:success] = "Post created!"
      end
    else
    end
  end

  def destroy
    @id = @post.id 
    @post.destroy
    respond_to do |format|
     format.html { redirect_to @activity, format: 'js' }
     format.js { }
   end
 end

 private

 def correct_user
  @post = current_user.posts.find(params[:id])
rescue
  redirect_to root_url
end



end