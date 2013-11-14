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

    Notificationtypeenum.add_item :CU, "CU"
    Notificationtypeenum.add_item :EMAIL, "EMAIL"
    Notificationtypeenum.add_item :PHONE, "PHONE"
    Notificationtypeenum.add_item :CU_EMAIL, "CU_EMAIL"
    Notificationtypeenum.add_item :CU_PHONE, "CU_PHONE"
    Notificationtypeenum.add_item :CU_EMAIL_PHONE, "CU_EMAIL_PHONE"
end
