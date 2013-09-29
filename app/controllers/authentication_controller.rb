class AuthenticationController < ApplicationController
  
  def index
  	 @authentications = current_user.authentications if current_user
  end

  def create

  omniauth = request.env["omniauth.auth"]
  authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  session['fb_auth'] = omniauth
  session['fb_access_token'] = omniauth['credentials']['token']
  session['fb_error'] = nil

  #if params[:code]
     # acknowledge code and get access token from FB
   #  session[:access_token] = session[:oauth].get_access_token(params[:code])
  #end

  if authentication
    flash[:notice] = "Signed in successfully."
    user = User.find(authentication.user_id)
    sign_in user
    redirect_back_or user
    #sign_in_and_redirect(:user, authentication.user)
  elsif current_user
    current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :username => omniauth['info']['nickname'])
    flash[:notice] = "Authentication successful."
    redirect_to authentications_url
  else
    user = User.new
    @existing_user = User.find_by_email(omniauth['info']['email'])
    unless @existing_user.nil?
        user = @existing_user
    end
    if params[:provider] == 'identity'
        #authentication = Authentication.find_by_uid(authentication.uid)
           if authentication.nil?
            # If no authentication was found, create a brand new one here
              authentication = Authentication.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :user_id => omniauth['uid'])
          end
          user = User.find(authentication.uid)
           flash[:notice] = "Signed up successfully."
           # Tell the UserMailer to send a welcome Email after save
          UserMailer.welcome_email(user).deliver
    else
      
      #user.authentications.build(:provider => omniauth ['provider'], :uid => omniauth['uid'])
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :username => omniauth['info']['nickname'])
      #user.apply_omniauth(omniauth)
      user.name = omniauth['info']['name']
      user.email = omniauth['info']['email']
      user.token = omniauth['credentials']['token']

      user.password = rand(36**10).to_s(36)
      user.password_confirmation = user.password
      user.save!
      flash[:notice] = "Signed up successfully."
      #sign_in_and_redirect(:user, user)
      # Tell the UserMailer to send a welcome Email after save
        UserMailer.welcome_email(user).deliver
    end
    sign_in user
    redirect_back_or user
  end
  end

  def destroy
  @authentication = current_user.authentications.find(params[:id])
  @authentication.destroy
  flash[:notice] = "Successfully destroyed authentication."
  redirect_to authentications_url
  end

  def failure
  flash[:error] = 'Invalid email/password combination'
  redirect_to signin_path
  end
end
