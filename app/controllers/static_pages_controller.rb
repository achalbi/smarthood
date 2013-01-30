class StaticPagesController < ApplicationController
 def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
       @group_feed_items = current_user.posts.paginate(page: params[:page])
	    
    end
  end
  
  def help
  end

  def about
  end
end
