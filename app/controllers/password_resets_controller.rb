class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    if !user.nil?
    	user.send_password_reset
    	redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
    	render 'new' 
    end
  end

  def edit
   @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
   @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
         if @user.save
          redirect_to root_url
        else
          render 'edit'
           #redirect_back_or @user
        end
    else
      render 'edit'
    end
  end

  def add
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def token_edit
   @user = User.find_by_password_reset_token!(params[:id])
   @user.user_info = UserInfo.new
   @user.address = Address.new
  end

  def token_update
   @user = User.find_by_password_reset_token!(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      redirect_to root_url
    else
      render 'token_edit'
       #redirect_back_or @user
    end
  end
end
