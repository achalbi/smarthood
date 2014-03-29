class StaticPagesController < ApplicationController
 def home
    if signed_in?
      @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
      @comm_id << active_community.id
      @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) 
      @selected_comm = []
      @selected_comm << active_community

      @post = Post.new
      @communities = Community.where('id IN (?) ', current_user.joined_uc.collect(&:community_id))
      @cu_ids = @communities.collect(&:id)
      @communityposts = Communitypost.where('community_id IN (?)', @cu_ids)
      @posts = @communityposts.paginate(page: params[:page], :per_page => 4).collect{|a| a.post}.uniq
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
  