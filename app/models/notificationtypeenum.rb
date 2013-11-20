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
    Notificationtypeenum.add_item :UPDATED, "updated"
    Notificationtypeenum.add_item :INVITED, "invited"
    Notificationtypeenum.add_item :REQUESTED, "requested"
    Notificationtypeenum.add_item :JOINED, "joined"
end
