module UsersHelper
require 'net/http'
require 'net/https' if RUBY_VERSION < '1.9'
require 'uri'

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_url = ""
    unless user.authentications.first.nil?
      auth = user.authentications.find_by_provider('facebook')
      unless auth.nil?
        gravatar_url = cloudinary_url( current_user.profile_pic, :width => 180, :height => 180, :crop => :fill, :gravity => :face)
       # gravatar_url = "https://graph.facebook.com/#{user.authentications.first.username}/picture?width=180&height=180"
          u = URI.parse(gravatar_url)
          head = Net::HTTP.get_response(u)
          gravatar_url = head['location']
      end
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar img-circle")
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_url = ""
    begin
      size = options[:size]
      unless user.authentications.first.nil?
        auth = user.authentications.find_by_provider('facebook')
        unless auth.nil?
        size = (size.to_i-10).to_s
          gravatar_url = cloudinary_url( current_user.profile_pic, :width => size, :height => size, :crop => :fill, :gravity => :face)
          #gravatar_url = "https://graph.facebook.com/#{auth.username}/picture?width=#{size}&height=#{size}"
            u = URI.parse(gravatar_url)
            head = Net::HTTP.get_response(u)
            gravatar_url = head['location']
        else
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"        
        end
      else
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      end
    rescue Exception => e
    end
      image_tag(gravatar_url, alt: user.name, class: "gravatar img-circle")
  end
  
    def gravatar_for_url(user, options = { size: 50 })
    gravatar_url = ""
    begin
        size = options[:size]
        unless user.authentications.first.nil?
          auth = user.authentications.find_by_provider('facebook')
        unless auth.nil?
            gravatar_url = cloudinary_url( current_user.profile_pic, :width => size, :height => size, :crop => :fill, :gravity => :face)
            #gravatar_url = "https://graph.facebook.com/#{auth.username}/picture?width=#{size}&height=#{size}"
            u = URI.parse(gravatar_url)
              h = Net::HTTP.new u.host, u.port
              h.use_ssl = u.scheme == 'https'
              head = h.start do |ua|
                ua.head u.path
              end
              gravatar_url = head['location']
          else
          gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
          gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"        
          end
        else
          gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
          gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        end
    rescue Exception => e
    end
    return gravatar_url
  end

  def fb_profile_pic_url(id, options = {size: 50})
    size = options[:size]
    fb_profile_pic_url = "https://graph.facebook.com/#{id}/picture?width=#{size}&height=#{size}"
  end

  def fb_profile_pic(id, options = {size: 50})
    size = options[:size]
    fb_profile_pic_url = "https://graph.facebook.com/#{id}/picture?width=#{size}&height=#{size}"
    image_tag(fb_profile_pic_url, alt: name, class: "gravatar img-circle")
  end
end
