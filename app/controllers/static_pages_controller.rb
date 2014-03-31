class StaticPagesController < ApplicationController
 def home
    if signed_in?
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
      #@posts = @communityposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq
      if current_user.address.nil? 
        current_user.address = Address.new
      end
    else
      @user = env['omniauth.identity'] ||= User.new
      @user.user_info = UserInfo.new
      @user.address = Address.new
    end
  end
  
  def help
  end

  def about
  end

end
  