class Activitytypeenum  
    def Activitytypeenum.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end

    def Activitytypeenum.const_missing(key)
        @hash[key]
    end    

    def Activitytypeenum.each
        @hash.each {|key,value| yield(key,value)}
    end

    Activitytypeenum.add_item :CREATED, "created"
    Activitytypeenum.add_item :UPDATED, "updated"
    Activitytypeenum.add_item :DELETED, "deleted"
    Activitytypeenum.add_item :JOINED, "joined"
end
