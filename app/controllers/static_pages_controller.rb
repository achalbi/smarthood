class StaticPagesController < ApplicationController
 def home
    if signed_in?
=begin
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 8)
      # @group_feed_items = current_user.posts.paginate(page: params[:page])
	    @groupposts = Grouppost.find(:all, :conditions => {:group_id => current_user.user_groups.map{|a| a.group_id}})
      @group_feed_items = @groupposts.collect{|a| a.post}.uniq
      # @group_feed_items = @group_feed_items.
      @comments = Comment.new
      @post = @group_feed_items
=end


      @post = Post.new
      @cu_ids = current_user.communities.collect(&:id)
      @communities = Community.where('id IN (?)', @cu_ids)
      @communityposts = Communitypost.where('community_id IN (?)', @cu_ids)
      @posts = @communityposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq
    end
  end
  
  def help
  end

  def about
  end
end
  