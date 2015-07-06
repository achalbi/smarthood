{"filter":false,"title":"event.rb","tooltip":"/app/models/event.rb","undoManager":{"mark":100,"position":100,"stack":[[{"start":{"row":77,"column":20},"end":{"row":77,"column":21},"action":"remove","lines":["e"],"id":23}],[{"start":{"row":77,"column":19},"end":{"row":77,"column":20},"action":"remove","lines":["s"],"id":24}],[{"start":{"row":77,"column":18},"end":{"row":77,"column":19},"action":"remove","lines":["u"],"id":25}],[{"start":{"row":77,"column":17},"end":{"row":77,"column":18},"action":"remove","lines":["("],"id":26}],[{"start":{"row":77,"column":16},"end":{"row":77,"column":17},"action":"remove","lines":["?"],"id":27}],[{"start":{"row":77,"column":16},"end":{"row":77,"column":17},"action":"insert","lines":["_"],"id":28}],[{"start":{"row":77,"column":17},"end":{"row":77,"column":18},"action":"insert","lines":["e"],"id":29}],[{"start":{"row":77,"column":18},"end":{"row":77,"column":19},"action":"insert","lines":["v"],"id":30}],[{"start":{"row":77,"column":19},"end":{"row":77,"column":20},"action":"insert","lines":["n"],"id":31}],[{"start":{"row":77,"column":20},"end":{"row":77,"column":21},"action":"insert","lines":["e"],"id":32}],[{"start":{"row":77,"column":20},"end":{"row":77,"column":21},"action":"remove","lines":["e"],"id":33}],[{"start":{"row":77,"column":19},"end":{"row":77,"column":20},"action":"remove","lines":["n"],"id":34}],[{"start":{"row":77,"column":19},"end":{"row":77,"column":20},"action":"insert","lines":["e"],"id":35}],[{"start":{"row":77,"column":20},"end":{"row":77,"column":21},"action":"insert","lines":["n"],"id":36}],[{"start":{"row":77,"column":21},"end":{"row":77,"column":22},"action":"insert","lines":["t"],"id":37}],[{"start":{"row":77,"column":28},"end":{"row":77,"column":29},"action":"insert","lines":[","],"id":38}],[{"start":{"row":77,"column":29},"end":{"row":77,"column":30},"action":"insert","lines":[" "],"id":39}],[{"start":{"row":77,"column":30},"end":{"row":77,"column":31},"action":"insert","lines":["e"],"id":40}],[{"start":{"row":77,"column":31},"end":{"row":77,"column":32},"action":"insert","lines":["v"],"id":41}],[{"start":{"row":77,"column":32},"end":{"row":77,"column":33},"action":"insert","lines":["e"],"id":42}],[{"start":{"row":77,"column":33},"end":{"row":77,"column":34},"action":"insert","lines":["n"],"id":43}],[{"start":{"row":77,"column":34},"end":{"row":77,"column":35},"action":"insert","lines":["t"],"id":44}],[{"start":{"row":77,"column":30},"end":{"row":77,"column":35},"action":"remove","lines":["event"],"id":45},{"start":{"row":77,"column":30},"end":{"row":77,"column":35},"action":"insert","lines":["event"]}],[{"start":{"row":77,"column":30},"end":{"row":77,"column":35},"action":"remove","lines":["event"],"id":46}],[{"start":{"row":77,"column":29},"end":{"row":77,"column":30},"action":"remove","lines":[" "],"id":47}],[{"start":{"row":77,"column":28},"end":{"row":77,"column":29},"action":"remove","lines":[","],"id":48}],[{"start":{"row":77,"column":1},"end":{"row":79,"column":5},"action":"remove","lines":[" def is_invited_event?(user)","    self.eventdetails.where(\"user_id = ? AND status=?\", user, \"invited\").exists?","  end"],"id":49}],[{"start":{"row":77,"column":1},"end":{"row":78,"column":0},"action":"remove","lines":["",""],"id":50}],[{"start":{"row":111,"column":5},"end":{"row":112,"column":0},"action":"insert","lines":["",""],"id":51},{"start":{"row":112,"column":0},"end":{"row":112,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":112,"column":2},"end":{"row":113,"column":0},"action":"insert","lines":["",""],"id":52},{"start":{"row":113,"column":0},"end":{"row":113,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":113,"column":2},"end":{"row":123,"column":5},"action":"insert","lines":["def is_invited?(user, community)","    unless community.usercommunities.nil?","     @usercommunity = community.usercommunities.where(\"user_id = ?  AND invitation = ?\",user, Uc_enum::INVITED )","        if @usercommunity.size > 0","         return true","        else","          return false","        end","    end","    return false","end  "],"id":53}],[{"start":{"row":113,"column":24},"end":{"row":113,"column":33},"action":"remove","lines":["community"],"id":54},{"start":{"row":113,"column":24},"end":{"row":113,"column":29},"action":"insert","lines":["event"]}],[{"start":{"row":114,"column":11},"end":{"row":114,"column":20},"action":"remove","lines":["community"],"id":55},{"start":{"row":114,"column":11},"end":{"row":114,"column":16},"action":"insert","lines":["event"]}],[{"start":{"row":114,"column":17},"end":{"row":114,"column":32},"action":"remove","lines":["usercommunities"],"id":56},{"start":{"row":114,"column":17},"end":{"row":114,"column":18},"action":"insert","lines":["u"]}],[{"start":{"row":114,"column":18},"end":{"row":114,"column":19},"action":"insert","lines":["s"],"id":57}],[{"start":{"row":114,"column":19},"end":{"row":114,"column":20},"action":"insert","lines":["e"],"id":58}],[{"start":{"row":114,"column":20},"end":{"row":114,"column":21},"action":"insert","lines":["r"],"id":59}],[{"start":{"row":114,"column":21},"end":{"row":114,"column":22},"action":"insert","lines":["e"],"id":60}],[{"start":{"row":114,"column":22},"end":{"row":114,"column":23},"action":"insert","lines":["v"],"id":61}],[{"start":{"row":114,"column":23},"end":{"row":114,"column":24},"action":"insert","lines":["e"],"id":62}],[{"start":{"row":114,"column":24},"end":{"row":114,"column":25},"action":"insert","lines":["n"],"id":63}],[{"start":{"row":114,"column":25},"end":{"row":114,"column":26},"action":"insert","lines":["t"],"id":64}],[{"start":{"row":114,"column":26},"end":{"row":114,"column":27},"action":"insert","lines":["s"],"id":65}],[{"start":{"row":115,"column":22},"end":{"row":115,"column":31},"action":"remove","lines":["community"],"id":66},{"start":{"row":115,"column":22},"end":{"row":115,"column":27},"action":"insert","lines":["event"]}],[{"start":{"row":115,"column":28},"end":{"row":115,"column":43},"action":"remove","lines":["usercommunities"],"id":67},{"start":{"row":115,"column":28},"end":{"row":115,"column":38},"action":"insert","lines":["userevents"]}],[{"start":{"row":114,"column":17},"end":{"row":114,"column":27},"action":"remove","lines":["userevents"],"id":68},{"start":{"row":114,"column":17},"end":{"row":114,"column":36},"action":"insert","lines":["event_invited_users"]}],[{"start":{"row":115,"column":28},"end":{"row":115,"column":38},"action":"remove","lines":["userevents"],"id":69},{"start":{"row":115,"column":28},"end":{"row":115,"column":47},"action":"insert","lines":["event_invited_users"]}],[{"start":{"row":113,"column":16},"end":{"row":113,"column":17},"action":"insert","lines":["_"],"id":70}],[{"start":{"row":113,"column":17},"end":{"row":113,"column":18},"action":"insert","lines":["e"],"id":71}],[{"start":{"row":113,"column":18},"end":{"row":113,"column":19},"action":"insert","lines":["v"],"id":72}],[{"start":{"row":113,"column":19},"end":{"row":113,"column":20},"action":"insert","lines":["e"],"id":73}],[{"start":{"row":113,"column":20},"end":{"row":113,"column":21},"action":"insert","lines":["n"],"id":74}],[{"start":{"row":113,"column":21},"end":{"row":113,"column":22},"action":"insert","lines":["t"],"id":75}],[{"start":{"row":123,"column":0},"end":{"row":123,"column":2},"action":"insert","lines":["  "],"id":76}],[{"start":{"row":113,"column":1},"end":{"row":124,"column":0},"action":"remove","lines":[" def is_invited_event?(user, event)","    unless event.event_invited_users.nil?","     @usercommunity = event.event_invited_users.where(\"user_id = ?  AND invitation = ?\",user, Uc_enum::INVITED )","        if @usercommunity.size > 0","         return true","        else","          return false","        end","    end","    return false","  end  ",""],"id":77}],[{"start":{"row":113,"column":0},"end":{"row":114,"column":0},"action":"remove","lines":[" ",""],"id":78}],[{"start":{"row":113,"column":0},"end":{"row":114,"column":0},"action":"remove","lines":["",""],"id":79}],[{"start":{"row":112,"column":2},"end":{"row":113,"column":0},"action":"insert","lines":["",""],"id":80},{"start":{"row":113,"column":0},"end":{"row":113,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":113,"column":2},"end":{"row":114,"column":0},"action":"insert","lines":["",""],"id":81},{"start":{"row":114,"column":0},"end":{"row":114,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":113,"column":2},"end":{"row":124,"column":0},"action":"insert","lines":[" def is_invited_event?(user, event)","    unless event.event_invited_users.nil?","     @usercommunity = event.event_invited_users.where(\"user_id = ?  AND invitation = ?\",user, Uc_enum::INVITED )","        if @usercommunity.size > 0","         return true","        else","          return false","        end","    end","    return false","  end  ",""],"id":82}],[{"start":{"row":113,"column":35},"end":{"row":113,"column":36},"action":"remove","lines":["t"],"id":83}],[{"start":{"row":113,"column":34},"end":{"row":113,"column":35},"action":"remove","lines":["n"],"id":84}],[{"start":{"row":113,"column":33},"end":{"row":113,"column":34},"action":"remove","lines":["e"],"id":85}],[{"start":{"row":113,"column":32},"end":{"row":113,"column":33},"action":"remove","lines":["v"],"id":86}],[{"start":{"row":113,"column":31},"end":{"row":113,"column":32},"action":"remove","lines":["e"],"id":87}],[{"start":{"row":113,"column":30},"end":{"row":113,"column":31},"action":"remove","lines":[" "],"id":88}],[{"start":{"row":113,"column":29},"end":{"row":113,"column":30},"action":"remove","lines":[","],"id":89}],[{"start":{"row":114,"column":11},"end":{"row":114,"column":16},"action":"remove","lines":["event"],"id":90},{"start":{"row":114,"column":11},"end":{"row":114,"column":12},"action":"insert","lines":["s"]}],[{"start":{"row":114,"column":12},"end":{"row":114,"column":13},"action":"insert","lines":["e"],"id":91}],[{"start":{"row":114,"column":13},"end":{"row":114,"column":14},"action":"insert","lines":["l"],"id":92}],[{"start":{"row":114,"column":14},"end":{"row":114,"column":15},"action":"insert","lines":["f"],"id":93}],[{"start":{"row":115,"column":22},"end":{"row":115,"column":27},"action":"remove","lines":["event"],"id":94},{"start":{"row":115,"column":22},"end":{"row":115,"column":23},"action":"insert","lines":["s"]}],[{"start":{"row":115,"column":23},"end":{"row":115,"column":24},"action":"insert","lines":["e"],"id":95}],[{"start":{"row":115,"column":24},"end":{"row":115,"column":25},"action":"insert","lines":["l"],"id":96}],[{"start":{"row":115,"column":25},"end":{"row":115,"column":26},"action":"insert","lines":["f"],"id":97}],[{"start":{"row":115,"column":5},"end":{"row":115,"column":6},"action":"remove","lines":["@"],"id":98}],[{"start":{"row":116,"column":11},"end":{"row":116,"column":12},"action":"remove","lines":["@"],"id":99}],[{"start":{"row":115,"column":5},"end":{"row":115,"column":18},"action":"remove","lines":["usercommunity"],"id":100},{"start":{"row":115,"column":5},"end":{"row":115,"column":24},"action":"insert","lines":["event_invited_users"]}],[{"start":{"row":116,"column":11},"end":{"row":116,"column":24},"action":"remove","lines":["usercommunity"],"id":101},{"start":{"row":116,"column":11},"end":{"row":116,"column":30},"action":"insert","lines":["event_invited_users"]}],[{"start":{"row":116,"column":25},"end":{"row":116,"column":26},"action":"remove","lines":["u"],"id":102}],[{"start":{"row":116,"column":24},"end":{"row":116,"column":25},"action":"remove","lines":["_"],"id":103}],[{"start":{"row":116,"column":24},"end":{"row":116,"column":25},"action":"insert","lines":["U"],"id":104}],[{"start":{"row":116,"column":17},"end":{"row":116,"column":18},"action":"remove","lines":["i"],"id":105}],[{"start":{"row":116,"column":16},"end":{"row":116,"column":17},"action":"remove","lines":["_"],"id":106}],[{"start":{"row":116,"column":16},"end":{"row":116,"column":17},"action":"insert","lines":["I"],"id":107}],[{"start":{"row":115,"column":5},"end":{"row":115,"column":24},"action":"remove","lines":["event_invited_users"],"id":108},{"start":{"row":115,"column":5},"end":{"row":115,"column":22},"action":"insert","lines":["eventInvitedUsers"]}],[{"start":{"row":113,"column":1},"end":{"row":125,"column":2},"action":"remove","lines":["  def is_invited_event?(user)","    unless self.event_invited_users.nil?","     eventInvitedUsers = self.event_invited_users.where(\"user_id = ?  AND invitation = ?\",user, Uc_enum::INVITED )","        if eventInvitedUsers.size > 0","         return true","        else","          return false","        end","    end","    return false","  end  ","","  "],"id":109}],[{"start":{"row":113,"column":0},"end":{"row":113,"column":1},"action":"remove","lines":[" "],"id":110}],[{"start":{"row":112,"column":2},"end":{"row":113,"column":0},"action":"remove","lines":["",""],"id":111}],[{"start":{"row":76,"column":5},"end":{"row":77,"column":0},"action":"insert","lines":["",""],"id":112},{"start":{"row":77,"column":0},"end":{"row":77,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":77,"column":2},"end":{"row":78,"column":0},"action":"insert","lines":["",""],"id":113},{"start":{"row":78,"column":0},"end":{"row":78,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":78,"column":2},"end":{"row":80,"column":5},"action":"insert","lines":[" def responded?(user)","    self.eventdetails.where(\"user_id = ? AND status!=?\", user, \"invited\").exists?","  end"],"id":114}],[{"start":{"row":78,"column":7},"end":{"row":78,"column":16},"action":"remove","lines":["responded"],"id":115},{"start":{"row":78,"column":7},"end":{"row":78,"column":8},"action":"insert","lines":["i"]}],[{"start":{"row":78,"column":8},"end":{"row":78,"column":9},"action":"insert","lines":["n"],"id":116}],[{"start":{"row":78,"column":9},"end":{"row":78,"column":10},"action":"insert","lines":["v"],"id":117}],[{"start":{"row":78,"column":10},"end":{"row":78,"column":11},"action":"insert","lines":["i"],"id":118}],[{"start":{"row":78,"column":11},"end":{"row":78,"column":12},"action":"insert","lines":["t"],"id":119}],[{"start":{"row":78,"column":12},"end":{"row":78,"column":13},"action":"insert","lines":["e"],"id":120}],[{"start":{"row":78,"column":13},"end":{"row":78,"column":14},"action":"insert","lines":["d"],"id":121}],[{"start":{"row":78,"column":7},"end":{"row":78,"column":14},"action":"remove","lines":["invited"],"id":122},{"start":{"row":78,"column":7},"end":{"row":78,"column":14},"action":"insert","lines":["invited"]}],[{"start":{"row":79,"column":51},"end":{"row":79,"column":52},"action":"remove","lines":["!"],"id":123}]]},"ace":{"folds":[],"scrolltop":695.5,"scrollleft":0,"selection":{"start":{"row":78,"column":7},"end":{"row":78,"column":14},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1436176422908,"hash":"fe1ffe5c3794a736f385d9a661276c2ef925e0e7"}