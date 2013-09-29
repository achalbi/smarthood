module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_url = ""
    unless user.authentications.first.nil?
      auth = user.authentications.find_by_provider('facebook')
      unless auth.nil?
        gravatar_url = "http://graph.facebook.com/#{user.authentications.first.username}/picture?width=180&height=180"
      end
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_url = ""
    size = options[:size]
    unless user.authentications.first.nil?
      size = (size.to_i-10).to_s
      auth = user.authentications.find_by_provider('facebook')
      unless auth.nil?
        gravatar_url = "http://graph.facebook.com/#{auth.username}/picture?width=#{size}&height=#{size}"
      else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"        
      end
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
    def gravatar_for_url(user, options = { size: 50 })
    gravatar_url = ""
    size = options[:size]
    unless user.authentications.first.nil?
      auth = user.authentications.find_by_provider('facebook')
    unless auth.nil?
        gravatar_url = "http://graph.facebook.com/#{auth.username}/picture?width=#{size}&height=#{size}"
      else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"        
      end
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
    return gravatar_url
  end
end
