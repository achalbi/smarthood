class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def new
     @user = env['omniauth.identity'] ||= User.new
     
  end

  def show
  	@user = User.find(params[:id])
    if @user.user_info.nil?
      @user.user_info = UserInfo.new
    end
    @post = Post.new
    @posts = @user.posts.uniq 
    if @user.address.nil? 
        @user.address = Address.new
    end
  end

  def create
  	@user = User.new(params[:user])
    @user.name = @user.user_info.first_name+@user.user_info.last_name
  	if @user.save
  		#flash[:success] = "User Created successfully!!!"
      # Tell the UserMailer to send a welcome Email after save
        UserMailer.welcome_email(@user).deliver
        sign_in @user
  		  redirect_to @user
  	else 
  		render 'new'
  	end	
  end

  def search_auto
    @users = User.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @users.map(&:attributes) }
    end
  end

 def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.user_info.update_attributes(params[:user][:user_info_attributes])
    if @user.update_attributes(params[:user])
      #flash[:success] = "Profile updated"
      sign_in @user
      #redirect_to @user
    end
  end

  def index
    @user = current_user
    @users = active_community_users.paginate(page: params[:page], :per_page => 20)
    @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
    @comm_id << active_community.id
    @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) 
    @selected_comm = []
    @selected_comm << active_community
  end

    def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], :per_page => 8)
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], :per_page => 8)
  end

  def search_user
    @users = User.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @users.map(&:attributes) }
    end
  end

  def search_users
    @comm_ids = params[:search][:community_id]
    @selected_comm = Community.where(['id IN (?)', @comm_ids])
    @cu_users = []
    @selected_comm.each do |cu|
      cu.users.each do |user|
        @cu_users << user
      end
    end
    @users = @cu_users.uniq
  end

  def update_user_info_from_fb
    user = session['fb_auth']['extra']['raw_info']
    @user.user_info.first_name = user['first_name']
    @user.user_info.last_name = user['last_name']
    @user.email = user['email']
    @user.user_info.gender = user['gender']
    @user.user_info.dob = user['birthday']

  end

 private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end



  def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
