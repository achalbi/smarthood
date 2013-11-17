class Notificationtypeenum  
    def Notificationtypeenum.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Notificationtypeenum.const_missing(key)
        @hash[key]
    end    

    def Notificationtypeenum.each
        @hash.each {|key,value| yield(key,value)}
    end

    Notificationtypeenum.add_item :CREATED, "created"
    Notificationtypeenum.add_item :UPDATED, "Updated"
    Notificationtypeenum.add_item :INVITED, "Invited"
    Notificationtypeenum.add_item :JOINED, "Joined"
end
