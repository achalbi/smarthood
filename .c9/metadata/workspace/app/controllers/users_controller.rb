{"filter":false,"title":"users_controller.rb","tooltip":"/app/controllers/users_controller.rb","undoManager":{"mark":30,"position":30,"stack":[[{"start":{"row":0,"column":0},"end":{"row":1,"column":0},"action":"insert","lines":["<<<<<<< HEAD",""],"id":1},{"start":{"row":137,"column":0},"end":{"row":276,"column":0},"action":"insert","lines":["=======","class UsersController < ApplicationController","  before_filter :signed_in_user, ","                only: [:index, :edit, :update, :destroy, :following, :followers]","  before_filter :correct_user,   only: [:edit, :update]","  before_filter :admin_user,     only: :destroy","","  def new","    if @user.nil?","     @user = env['omniauth.identity'] ||= User.new","    end","     ","  end","","  def show","  \t@user = User.find(params[:id])","    if @user.user_info.nil?","      @user.user_info = UserInfo.new","    end","    @post = Post.new","    @posts = @user.posts.uniq ","    if @user.address.nil? ","        @user.address = Address.new","    end","  end","","  def create","    @user = User.new(params[:user])","    @user.name = @user.user_info.first_name+\" \"+@user.user_info.last_name","    #@user.valid = true","  \tif @user.save","      authentication = Authentication.create(:provider => 'identity', :uid => @user.id, :user_id => @user.id)","  \t\t#flash[:success] = \"User Created successfully!!!\"","      # Tell the UserMailer to send a welcome Email after save","      # UserMailer.delay.welcome_email(@user)","      UserMailer.welcome_email(user).deliver","        sign_in @user","  \t\t  redirect_to root_path","  \telse ","  \t\trender 'new'","  \tend\t","  end","","  def search_auto","    @users = User.where(\"name like ?\", \"%#{params[:q]}%\")","    respond_to do |format|","      format.html","      format.json { render :json => @users.map(&:attributes) }","    end","  end",""," def edit","    @user = User.find(params[:id])","  end","","  def update","    @user = User.find(params[:id])","    @user.user_info.update_attributes(params[:user][:user_info_attributes])","    if @user.update_attributes(params[:user])","      #flash[:success] = \"Profile updated\"","      sign_in @user","      #redirect_to @user","    end","  end","","  def index","    @user = current_user","    @users = active_community_users.paginate(page: params[:page], :per_page => 20)","    @comm_id = current_user.usercommunities.where(\"is_admin=? OR invitation != ?\", true, Uc_enum::JOINED ).collect(&:community_id)","    @comm_id << active_community.id","    @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) ","    @selected_comm = []","    @selected_comm << active_community","  end","","    def destroy","    User.find(params[:id]).destroy","    flash[:success] = \"User destroyed.\"","    redirect_to users_url","  end","","  def following","    @title = \"Following\"","    @user = User.find(params[:id])","    @users = @user.followed_users.paginate(page: params[:page], :per_page => 8)","  end","","  def followers","    @title = \"Followers\"","    @user = User.find(params[:id])","    @users = @user.followers.paginate(page: params[:page], :per_page => 8)","  end","","  def search_user","    @users = User.where(\"name like ?\", \"%#{params[:q]}%\")","    respond_to do |format|","      format.html","      format.json { render :json => @users.map(&:attributes) }","    end","  end","","  def search_users","    @comm_ids = params[:search][:community_id]","    @selected_comm = Community.where(['id IN (?)', @comm_ids])","    @cu_users = []","    @selected_comm.each do |cu|","      cu.users.each do |user|","        @cu_users << user","      end","    end","    @users = @cu_users.uniq","  end","","  def update_user_info_from_fb","    user = session['fb_auth']['extra']['raw_info']","    @user.user_info.first_name = user['first_name']","    @user.user_info.last_name = user['last_name']","    @user.email = user['email']","    @user.user_info.gender = user['gender']","    @user.user_info.dob = user['birthday']","","  end",""," private","","","    def correct_user","      @user = User.find(params[:id])","      redirect_to(root_path) unless current_user?(@user)","    end","","","","  def admin_user","      redirect_to(root_path) unless current_user.admin?","    end","","end",">>>>>>> 3e87424edbcf3c2a32452d982f8ac532c5960c7d",""]}],[{"start":{"row":0,"column":11},"end":{"row":0,"column":12},"action":"remove","lines":["D"],"id":2}],[{"start":{"row":0,"column":10},"end":{"row":0,"column":11},"action":"remove","lines":["A"],"id":3}],[{"start":{"row":0,"column":9},"end":{"row":0,"column":10},"action":"remove","lines":["E"],"id":4}],[{"start":{"row":0,"column":8},"end":{"row":0,"column":9},"action":"remove","lines":["H"],"id":5}],[{"start":{"row":0,"column":7},"end":{"row":0,"column":8},"action":"remove","lines":[" "],"id":6}],[{"start":{"row":0,"column":6},"end":{"row":0,"column":7},"action":"remove","lines":["<"],"id":7}],[{"start":{"row":0,"column":5},"end":{"row":0,"column":6},"action":"remove","lines":["<"],"id":8}],[{"start":{"row":0,"column":4},"end":{"row":0,"column":5},"action":"remove","lines":["<"],"id":9}],[{"start":{"row":0,"column":3},"end":{"row":0,"column":4},"action":"remove","lines":["<"],"id":10}],[{"start":{"row":0,"column":2},"end":{"row":0,"column":3},"action":"remove","lines":["<"],"id":11}],[{"start":{"row":0,"column":1},"end":{"row":0,"column":2},"action":"remove","lines":["<"],"id":12}],[{"start":{"row":0,"column":0},"end":{"row":0,"column":1},"action":"remove","lines":["<"],"id":13}],[{"start":{"row":0,"column":0},"end":{"row":1,"column":0},"action":"remove","lines":["",""],"id":14}],[{"start":{"row":136,"column":0},"end":{"row":274,"column":48},"action":"remove","lines":["=======","class UsersController < ApplicationController","  before_filter :signed_in_user, ","                only: [:index, :edit, :update, :destroy, :following, :followers]","  before_filter :correct_user,   only: [:edit, :update]","  before_filter :admin_user,     only: :destroy","","  def new","    if @user.nil?","     @user = env['omniauth.identity'] ||= User.new","    end","     ","  end","","  def show","  \t@user = User.find(params[:id])","    if @user.user_info.nil?","      @user.user_info = UserInfo.new","    end","    @post = Post.new","    @posts = @user.posts.uniq ","    if @user.address.nil? ","        @user.address = Address.new","    end","  end","","  def create","    @user = User.new(params[:user])","    @user.name = @user.user_info.first_name+\" \"+@user.user_info.last_name","    #@user.valid = true","  \tif @user.save","      authentication = Authentication.create(:provider => 'identity', :uid => @user.id, :user_id => @user.id)","  \t\t#flash[:success] = \"User Created successfully!!!\"","      # Tell the UserMailer to send a welcome Email after save","      # UserMailer.delay.welcome_email(@user)","      UserMailer.welcome_email(user).deliver","        sign_in @user","  \t\t  redirect_to root_path","  \telse ","  \t\trender 'new'","  \tend\t","  end","","  def search_auto","    @users = User.where(\"name like ?\", \"%#{params[:q]}%\")","    respond_to do |format|","      format.html","      format.json { render :json => @users.map(&:attributes) }","    end","  end",""," def edit","    @user = User.find(params[:id])","  end","","  def update","    @user = User.find(params[:id])","    @user.user_info.update_attributes(params[:user][:user_info_attributes])","    if @user.update_attributes(params[:user])","      #flash[:success] = \"Profile updated\"","      sign_in @user","      #redirect_to @user","    end","  end","","  def index","    @user = current_user","    @users = active_community_users.paginate(page: params[:page], :per_page => 20)","    @comm_id = current_user.usercommunities.where(\"is_admin=? OR invitation != ?\", true, Uc_enum::JOINED ).collect(&:community_id)","    @comm_id << active_community.id","    @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) ","    @selected_comm = []","    @selected_comm << active_community","  end","","    def destroy","    User.find(params[:id]).destroy","    flash[:success] = \"User destroyed.\"","    redirect_to users_url","  end","","  def following","    @title = \"Following\"","    @user = User.find(params[:id])","    @users = @user.followed_users.paginate(page: params[:page], :per_page => 8)","  end","","  def followers","    @title = \"Followers\"","    @user = User.find(params[:id])","    @users = @user.followers.paginate(page: params[:page], :per_page => 8)","  end","","  def search_user","    @users = User.where(\"name like ?\", \"%#{params[:q]}%\")","    respond_to do |format|","      format.html","      format.json { render :json => @users.map(&:attributes) }","    end","  end","","  def search_users","    @comm_ids = params[:search][:community_id]","    @selected_comm = Community.where(['id IN (?)', @comm_ids])","    @cu_users = []","    @selected_comm.each do |cu|","      cu.users.each do |user|","        @cu_users << user","      end","    end","    @users = @cu_users.uniq","  end","","  def update_user_info_from_fb","    user = session['fb_auth']['extra']['raw_info']","    @user.user_info.first_name = user['first_name']","    @user.user_info.last_name = user['last_name']","    @user.email = user['email']","    @user.user_info.gender = user['gender']","    @user.user_info.dob = user['birthday']","","  end",""," private","","","    def correct_user","      @user = User.find(params[:id])","      redirect_to(root_path) unless current_user?(@user)","    end","","","","  def admin_user","      redirect_to(root_path) unless current_user.admin?","    end","","end",">>>>>>> 3e87424edbcf3c2a32452d982f8ac532c5960c7d"],"id":15}],[{"start":{"row":27,"column":43},"end":{"row":27,"column":44},"action":"insert","lines":["+"],"id":17}],[{"start":{"row":27,"column":44},"end":{"row":27,"column":45},"action":"insert","lines":["\""],"id":18}],[{"start":{"row":27,"column":45},"end":{"row":27,"column":46},"action":"insert","lines":["\""],"id":19}],[{"start":{"row":27,"column":45},"end":{"row":27,"column":46},"action":"insert","lines":[" "],"id":20}],[{"start":{"row":27,"column":46},"end":{"row":27,"column":47},"action":"insert","lines":["v"],"id":21}],[{"start":{"row":27,"column":46},"end":{"row":27,"column":47},"action":"remove","lines":["v"],"id":22}],[{"start":{"row":27,"column":43},"end":{"row":27,"column":44},"action":"insert","lines":["."],"id":23}],[{"start":{"row":27,"column":44},"end":{"row":27,"column":45},"action":"insert","lines":["t"],"id":24}],[{"start":{"row":27,"column":45},"end":{"row":27,"column":46},"action":"insert","lines":["o"],"id":25}],[{"start":{"row":27,"column":46},"end":{"row":27,"column":47},"action":"insert","lines":["_"],"id":26}],[{"start":{"row":27,"column":47},"end":{"row":27,"column":48},"action":"insert","lines":["s"],"id":27}],[{"start":{"row":27,"column":78},"end":{"row":27,"column":79},"action":"insert","lines":["."],"id":28}],[{"start":{"row":27,"column":79},"end":{"row":27,"column":80},"action":"insert","lines":["t"],"id":29}],[{"start":{"row":27,"column":80},"end":{"row":27,"column":81},"action":"insert","lines":["o"],"id":30}],[{"start":{"row":27,"column":81},"end":{"row":27,"column":82},"action":"insert","lines":["_"],"id":31}],[{"start":{"row":27,"column":82},"end":{"row":27,"column":83},"action":"insert","lines":["s"],"id":32}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":30,"column":23},"end":{"row":30,"column":37},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":23,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1437558710405,"hash":"f3d5910cec5105e7e8b99da1bcd50dcf46d7c54a"}