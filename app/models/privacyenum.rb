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

    Privacyenum.add_item :PUBLIC, 1
    Privacyenum.add_item :PRIVATE, 2
    Privacyenum.add_item :MEMBERS, 3
    Privacyenum.add_item :CUSTOM, 4
    Privacyenum.add_item :SECRET, 5
    Privacyenum.add_item :INDIVIDUAL, 6
end
