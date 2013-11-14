class Privacyenum  
    def Privacyenum.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Privacyenum.const_missing(key)
        @hash[key]
    end    

    def Privacyenum.each
        @hash.each {|key,value| yield(key,value)}
    end

    Privacyenum.add_item :PUBLIC, "PUBLIC"
    Privacyenum.add_item :PRIVATE, "PRIVATE"
    Privacyenum.add_item :SECRET, "SECRET"
    Privacyenum.add_item :MEMBERS, "MEMBERS"
    Privacyenum.add_item :CUSTOM, "CUSTOM"
    Privacyenum.add_item :INDIVIDUAL, "INDIVIDUAL"
end
