module SessionsHelper
	def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
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
    cookies.delete(:remember_token)
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
        redirect_to signin_url, notice: "Please sign in."
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

  def active_community
    Community.find(Usercommunity.where(['status=? and user_id=?','active',current_user.id])[0].community_id)
  end

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '117.192.176.246'
    else
      request.remote_ip
    end
  end
  
end
