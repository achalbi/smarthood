class UserMailer < ActionMailer::Base
  default from: "smarthood.in@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
def password_reset(user)
  @user = user
  mail :to => user.email, :subject => "Password Reset"
end

  def welcome_email(user)
    @user = user
    @url  = "http://smarthood.in/"
   # attachments.inline['image.jpg'] = File.read(gravatar_for(user))
    attachments.inline['smarthood-s.png'] = File.read("#{Rails.root}/public/assets/smarthood-s.png")
    mail(:to => user.email, :subject => "Welcome to Rashi EMS")
  end

  def share_album(user,email,album)
    @user = user
    @url  = "http://smarthood.in/albums/#{album.id}"
   # attachments.inline['image.jpg'] = File.read(gravatar_for(user))
  #  attachments.inline['indy.png'] = File.read("#{Rails.root}/public/assets/indy.png")
    mail(:to => email, :subject => "Shared album - #{album.title}")
  end

  def invite_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Invite request to join ComUnity")
  end


end
