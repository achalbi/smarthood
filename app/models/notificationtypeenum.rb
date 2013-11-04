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

    Notificationtypeenum.add_item :EMAIL, "1"
    Notificationtypeenum.add_item :POPUP, "2"
    Notificationtypeenum.add_item :SIDEBAR, "3"
end
