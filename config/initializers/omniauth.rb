Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, fields: [:email], model: User, on_failed_registration: lambda { |env|      
    UsersController.action(:new).call(env)  
  }
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
 # provider :facebook, "536159993072259", "68fcf96519f8ecaab34473583bbaebb0", :scope => 'email,user_birthday,read_stream', :display => 'popup'
  provider :facebook, FACEBOOK_CONFIG['FACEBOOK_APP_ID'], FACEBOOK_CONFIG['FACEBOOK_SECRET'], :scope => 'email,user_birthday,read_stream', :display => 'touch'

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
  

end
