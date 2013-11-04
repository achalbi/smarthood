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

    Objecttypeenum.add_item :COMMUNITY_CREATE, "1"
    Objecttypeenum.add_item :COMMUNITY_DELETE, "2"
    Objecttypeenum.add_item :COMMUNITY_EDIT, "3"
    Objecttypeenum.add_item :COMMUNITY_INVITE_USERS, "4"
    Objecttypeenum.add_item :COMMUNITY_ADD_ADMIN, "5"
    Objecttypeenum.add_item :COMMUNITY_REMOVE_ADMIN, "6"
    
    Objecttypeenum.add_item :EVENT_CREATE, "7"
    Objecttypeenum.add_item :EVENT_DELETE, "8"
    Objecttypeenum.add_item :EVENT_EDIT, "9"
    Objecttypeenum.add_item :EVENT_INVITE_USERS, "10"
    
    Objecttypeenum.add_item :ACTIVITY_CREATE, "11"
    Objecttypeenum.add_item :ACTIVITY_DELETE, "12"
    Objecttypeenum.add_item :ACTIVITY_EDIT, "13"
    Objecttypeenum.add_item :ACTIVITY_INVITE_USERS, "14"

    Objecttypeenum.add_item :GROUP_CREATE, "15"
    Objecttypeenum.add_item :GROUP_DELETE, "16"
    Objecttypeenum.add_item :GROUP_EDIT, "17"
    Objecttypeenum.add_item :GROUP_INVITE_USERS, "18"
    
    Objecttypeenum.add_item :PHOTO_ADDED, "19"
    Objecttypeenum.add_item :PHOTO_DELETED, "20"

    Objecttypeenum.add_item :ALBUM_ADDED, "21"
    Objecttypeenum.add_item :ALBUM_DELETED, "22"

    Objecttypeenum.add_item :USER_REGISTRATION, "23"
    Objecttypeenum.add_item :POST, "24"
    Objecttypeenum.add_item :COMMENT, "25"


end
