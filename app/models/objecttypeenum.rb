class Objecttypeenum  
    def Objecttypeenum.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Objecttypeenum.const_missing(key)
        @hash[key]
    end    

    def Objecttypeenum.each
        @hash.each {|key,value| yield(key,value)}
    end

    Objecttypeenum.add_item :COMUNITY, "COMUNITY"
    Objecttypeenum.add_item :EVENT, "EVENT"
    Objecttypeenum.add_item :ACTIVITY, "ACTIVITY"
    Objecttypeenum.add_item :GROUP, "GROUP"
    Objecttypeenum.add_item :ALBUM, "ALBUM"
    Objecttypeenum.add_item :PHOTO, "PHOTO"
    Objecttypeenum.add_item :POST, "POST"
    Objecttypeenum.add_item :COMMENT, "COMMENT"
    Objecttypeenum.add_item :USER, "USER"

=begin
    Objecttypeenum.add_item :COMMUNITY_CREATE, "COMMUNITY_CREATE"
    Objecttypeenum.add_item :COMMUNITY_DELETE, "COMMUNITY_DELETE"
    Objecttypeenum.add_item :COMMUNITY_EDIT, "COMMUNITY_EDIT"
    Objecttypeenum.add_item :COMMUNITY_INVITE_USERS, "COMMUNITY_INVITE_USERS"
    Objecttypeenum.add_item :COMMUNITY_JOINED_USER, "COMMUNITY_JOINED_USER"
    Objecttypeenum.add_item :COMMUNITY_ADD_ADMIN, "COMMUNITY_ADD_ADMIN"
    Objecttypeenum.add_item :COMMUNITY_REMOVE_ADMIN, "COMMUNITY_REMOVE_ADMIN"
    
    Objecttypeenum.add_item :EVENT_CREATE, "EVENT_CREATE"
    Objecttypeenum.add_item :EVENT_DELETE, "EVENT_DELETE"
    Objecttypeenum.add_item :EVENT_EDIT, "EVENT_EDIT"
    Objecttypeenum.add_item :EVENT_INVITE_USERS, "EVENT_INVITE_USERS"
    Objecttypeenum.add_item :EVENT_JOINED_USERS, "EVENT_JOINED_USERS"
    
    Objecttypeenum.add_item :ACTIVITY_CREATE, "ACTIVITY_CREATE"
    Objecttypeenum.add_item :ACTIVITY_DELETE, "ACTIVITY_DELETE"
    Objecttypeenum.add_item :ACTIVITY_EDIT, "ACTIVITY_EDIT"
    Objecttypeenum.add_item :ACTIVITY_INVITE_USERS, "ACTIVITY_INVITE_USERS"

    Objecttypeenum.add_item :GROUP_CREATE, "GROUP_CREATE"
    Objecttypeenum.add_item :GROUP_DELETE, "GROUP_DELETE"
    Objecttypeenum.add_item :GROUP_EDIT, "GROUP_EDIT"
    Objecttypeenum.add_item :GROUP_INVITE_USERS, "GROUP_INVITE_USERS"
    
    Objecttypeenum.add_item :PHOTO_ADDED, "PHOTO_ADDED"
    Objecttypeenum.add_item :PHOTO_DELETED, "PHOTO_DELETED"

    Objecttypeenum.add_item :ALBUM_CREATED, "ALBUM_CREATED"
    Objecttypeenum.add_item :ALBUM_EDITED, "ALBUM_EDITED"
    Objecttypeenum.add_item :ALBUM_DELETED, "ALBUM_DELETED"

    Objecttypeenum.add_item :USER_REGISTRATION, "USER_REGISTRATION"
    Objecttypeenum.add_item :POST, "POST"
    Objecttypeenum.add_item :COMMENT, "COMMENT"
=end


end
