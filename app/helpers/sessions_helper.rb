module SessionsHelper
	def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
    session[:return_to] = root_url
  end

   def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    session.delete(:return_to)
    cookies.delete(:remember_token)
    session[:return_to] = root_url
  end

    def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end 

    def signed_in_user
      unless signed_in?
        store_location
        #redirect_to signin_url, notice: "Please sign in."
        redirect_to root_url, notice: "Please sign in."
      end
    end

  def is_community_active?
        @uc = Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0]
        unless @uc.nil?
          @selected_community = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
        end
        !@selected_community.nil?
  end

  def home_page
    if current_user.nil?
      return root_path
    end
    if is_community_active?
      return root_path
    else
      return communities_path
    end
  end
  
    
  def set_community_active(id)
  	 @usercommunity = Usercommunity.where(['status=? and user_id=?','active',current_user.id]).first
    unless @usercommunity.blank?
      @usercommunity.status=""
      @usercommunity.save
    end
  	@usercommunitySel = Usercommunity.where(['community_id=? and user_id=?',id,current_user.id]).first
    unless @usercommunitySel.blank?
    	@usercommunitySel.status="active"
    	@usercommunitySel.save
    else
       @usercommunity = Usercommunity.new 
       @usercommunity.community_id = '1'
       @usercommunity.user_id = current_user.id
       @usercommunity.invitation = Uc_enum::JOINED
       @usercommunity.is_admin = false
       @usercommunity.status="active"
       @usercommunity.save
    end
  end
  
  def length_trim(str,n)
    str.length > n ? str.slice(0..n) + "..." : str
  end

  def active_community
    unless signed_in?
      return Community.find_by_name('Smarthood')
    end
    if Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].nil?
       @usercommunity = Usercommunity.new 
       @usercommunity.community_id = Community.where(name: 'Smarthood')[0].id
       @usercommunity.user_id = current_user.id
       @usercommunity.invitation = Uc_enum::JOINED
       @usercommunity.is_admin = false
       @usercommunity.status="active"
       @usercommunity.save
    end
    @comm1 = Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
    @comm1.req_pending_cnt = User.where(['id IN (?)' , @comm1.requested_uc.collect(&:user_id)]).count
    return @comm1
  end

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '117.192.176.246'
    else
      request.remote_ip
    end
  end

  def fb_friends
      @friends = Array.new
    if session["fb_access_token"].present?
      graph = Koala::Facebook::API.new(session["fb_access_token"]) # Note that i'm using session here
      # @profile_image = graph.get_picture("me")
      # @fbprofile = graph.get_object("me")
      @friends = graph.get_connections("me", "friends")
    end
    @friends
  end

  def create_user_to_invite(uid,email)
    @user = User.new
    if !uid.nil?
      @user = User.find_by_fb_uid(uid)
      if @user.blank?
        @user = User.create(fb_uid: uid)
        graph = Koala::Facebook::API.new(session["fb_access_token"]) # Note that i'm using session here
        @user.name = graph.get_object(uid)["name"]
        #@user.valid = false
        @user.save(validate: false)
        @authentication = @user.authentications.build(:provider => 'facebook', :uid => uid, username: graph.get_object(uid)["username"] )
        @authentication.save
      end
    elsif !email.nil?
     @user = User.find_by_email(email)
      if @user.blank?
        @user = User.create(email: email)
         begin
          @user.send_token_for_user_to_join
         rescue
         end
        #@user.valid = false
        @user.save(validate: false)
        @authentication = Authentication.find_or_create_by_uid(@user.id.to_s)
        @authentication.provider = 'identity'
        @authentication.user_id = @user.id
        @authentication.uid = @user.id
        @authentication.save
      end
    end
    @user
  end 

  def active_community_users
    User.where("id in (?)",active_community.usercommunities.collect(&:user_id))
  end

  def active_community_user_ids
    active_community.usercommunities.collect(&:user_id)
  end

  def community_user_ids(id)
    @community = Community.find(id)
    @community.usercommunities.collect(&:user_id)
  end

  def notification_count
    Activitynotification.where("recepient_id = ? AND is_unread = ?", current_user.id, true ).count
  end

  def privacy_str(obj)
    if obj.privacy == Privacyenum::PUBLIC
      "Public"
    elsif obj.privacy == Privacyenum::PRIVATE
      "Private"
    elsif obj.privacy == Privacyenum::MEMBERS
      "Members"
    elsif obj.privacy == Privacyenum::CUSTOM
      "Custom"
    elsif obj.privacy == Privacyenum::INDIVIDUAL
      "Individual"
    elsif obj.privacy == Privacyenum::SECRET
      "Secret"  
    elsif obj.privacy == Privacyenum::PROTECTED
      "Protected"      
    end
  end
  
end
