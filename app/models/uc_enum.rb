class Uc_enum  
    def Uc_enum.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Uc_enum.const_missing(key)
        @hash[key]
    end    

    def Uc_enum.each
        @hash.each {|key,value| yield(key,value)}
    end

    Uc_enum.add_item :REQUESTED, "requested"
    Uc_enum.add_item :MODERATOR_DECLINED, "moderator_declined"
    Uc_enum.add_item :USER_DECLINED, "user_declined"
    Uc_enum.add_item :JOINED, "joined"
    Uc_enum.add_item :INVITED, "invited"
    Uc_enum.add_item :UNJOINED, "unjoined"
    Uc_enum.add_item :CREATED, "created"
    Uc_enum.add_item :UPDATED, "updated"
    Uc_enum.add_item :ACCEPTED, "accepted"
    Uc_enum.add_item :ADD_MODERATOR, "add_moderator"
    Uc_enum.add_item :SHARED, "shared"
    Uc_enum.add_item :YES, "yes"
    Uc_enum.add_item :NO, "no"
    Uc_enum.add_item :MAYBE, "maybe"
end
