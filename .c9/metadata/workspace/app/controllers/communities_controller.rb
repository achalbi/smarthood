{"filter":false,"title":"communities_controller.rb","tooltip":"/app/controllers/communities_controller.rb","undoManager":{"mark":100,"position":100,"stack":[[{"start":{"row":271,"column":39},"end":{"row":271,"column":40},"action":"insert","lines":["."],"id":68}],[{"start":{"row":271,"column":40},"end":{"row":271,"column":41},"action":"insert","lines":["t"],"id":69}],[{"start":{"row":271,"column":41},"end":{"row":271,"column":42},"action":"insert","lines":["o"],"id":70}],[{"start":{"row":271,"column":42},"end":{"row":271,"column":43},"action":"insert","lines":["_"],"id":71}],[{"start":{"row":271,"column":43},"end":{"row":271,"column":44},"action":"insert","lines":["i"],"id":72}],[{"start":{"row":303,"column":44},"end":{"row":303,"column":49},"action":"insert","lines":[".to_i"],"id":73}],[{"start":{"row":303,"column":2},"end":{"row":303,"column":8},"action":"remove","lines":["unless"],"id":74},{"start":{"row":303,"column":2},"end":{"row":303,"column":3},"action":"insert","lines":["i"]}],[{"start":{"row":303,"column":3},"end":{"row":303,"column":4},"action":"insert","lines":["f"],"id":75}],[{"start":{"row":304,"column":0},"end":{"row":305,"column":0},"action":"remove","lines":["    redirect_to  :action => 'members_com', :id => params[:id]",""],"id":77},{"start":{"row":305,"column":0},"end":{"row":306,"column":0},"action":"insert","lines":["    redirect_to  :action => 'members_com', :id => params[:id]",""]}],[{"start":{"row":304,"column":2},"end":{"row":305,"column":0},"action":"insert","lines":["",""],"id":78},{"start":{"row":305,"column":0},"end":{"row":305,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":304,"column":2},"end":{"row":304,"column":4},"action":"insert","lines":["  "],"id":79}],[{"start":{"row":304,"column":4},"end":{"row":304,"column":24},"action":"insert","lines":["redirect_to root_url"],"id":80}],[{"start":{"row":305,"column":0},"end":{"row":306,"column":0},"action":"remove","lines":["  end",""],"id":81},{"start":{"row":306,"column":0},"end":{"row":307,"column":0},"action":"insert","lines":["  end",""]}],[{"start":{"row":304,"column":24},"end":{"row":305,"column":0},"action":"insert","lines":["",""],"id":82},{"start":{"row":305,"column":0},"end":{"row":305,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":305,"column":4},"end":{"row":305,"column":5},"action":"insert","lines":["e"],"id":83}],[{"start":{"row":305,"column":5},"end":{"row":305,"column":6},"action":"insert","lines":["l"],"id":84}],[{"start":{"row":305,"column":6},"end":{"row":305,"column":7},"action":"insert","lines":["s"],"id":85}],[{"start":{"row":305,"column":7},"end":{"row":305,"column":8},"action":"insert","lines":["e"],"id":86},{"start":{"row":305,"column":2},"end":{"row":305,"column":4},"action":"remove","lines":["  "]}],[{"start":{"row":265,"column":4},"end":{"row":265,"column":61},"action":"remove","lines":["redirect_to  :action => 'members_com', :id => params[:id]"],"id":87},{"start":{"row":265,"column":4},"end":{"row":269,"column":5},"action":"insert","lines":["if current_user.id == params[:user_id].to_i","    redirect_to root_url","  else","    redirect_to  :action => 'members_com', :id => params[:id]","  end"]}],[{"start":{"row":266,"column":4},"end":{"row":266,"column":6},"action":"insert","lines":["  "],"id":88}],[{"start":{"row":267,"column":2},"end":{"row":267,"column":4},"action":"insert","lines":["  "],"id":89}],[{"start":{"row":264,"column":0},"end":{"row":265,"column":0},"action":"remove","lines":["    ",""],"id":90}],[{"start":{"row":265,"column":6},"end":{"row":265,"column":26},"action":"remove","lines":["redirect_to root_url"],"id":91},{"start":{"row":265,"column":6},"end":{"row":265,"column":62},"action":"insert","lines":[" render js: %(window.location.href='#{request.referer}')"]}],[{"start":{"row":267,"column":3},"end":{"row":267,"column":4},"action":"insert","lines":[" "],"id":92}],[{"start":{"row":267,"column":5},"end":{"row":267,"column":6},"action":"insert","lines":[" "],"id":93}],[{"start":{"row":307,"column":4},"end":{"row":307,"column":24},"action":"remove","lines":["redirect_to root_url"],"id":94},{"start":{"row":307,"column":4},"end":{"row":307,"column":54},"action":"insert","lines":[" render js: %(window.location.href='#{root_path}')"]}],[{"start":{"row":177,"column":0},"end":{"row":177,"column":2},"action":"insert","lines":["  "],"id":95}],[{"start":{"row":177,"column":2},"end":{"row":177,"column":3},"action":"insert","lines":["r"],"id":96}],[{"start":{"row":177,"column":3},"end":{"row":177,"column":4},"action":"insert","lines":["e"],"id":97}],[{"start":{"row":177,"column":4},"end":{"row":177,"column":5},"action":"insert","lines":["d"],"id":98}],[{"start":{"row":177,"column":5},"end":{"row":177,"column":6},"action":"insert","lines":["i"],"id":99}],[{"start":{"row":177,"column":6},"end":{"row":177,"column":7},"action":"insert","lines":["r"],"id":100}],[{"start":{"row":177,"column":7},"end":{"row":177,"column":8},"action":"insert","lines":["e"],"id":101}],[{"start":{"row":177,"column":8},"end":{"row":177,"column":9},"action":"insert","lines":["c"],"id":102}],[{"start":{"row":177,"column":9},"end":{"row":177,"column":10},"action":"insert","lines":["t"],"id":103}],[{"start":{"row":177,"column":2},"end":{"row":177,"column":10},"action":"remove","lines":["redirect"],"id":104},{"start":{"row":177,"column":2},"end":{"row":177,"column":13},"action":"insert","lines":["redirect_to"]}],[{"start":{"row":177,"column":13},"end":{"row":177,"column":14},"action":"insert","lines":[" "],"id":105}],[{"start":{"row":177,"column":14},"end":{"row":177,"column":15},"action":"insert","lines":["@"],"id":106}],[{"start":{"row":177,"column":15},"end":{"row":177,"column":16},"action":"insert","lines":["c"],"id":107}],[{"start":{"row":177,"column":16},"end":{"row":177,"column":17},"action":"insert","lines":["o"],"id":108}],[{"start":{"row":177,"column":17},"end":{"row":177,"column":18},"action":"insert","lines":["m"],"id":109}],[{"start":{"row":177,"column":18},"end":{"row":177,"column":19},"action":"insert","lines":["m"],"id":110}],[{"start":{"row":177,"column":15},"end":{"row":177,"column":19},"action":"remove","lines":["comm"],"id":111},{"start":{"row":177,"column":15},"end":{"row":177,"column":24},"action":"insert","lines":["community"]}],[{"start":{"row":177,"column":0},"end":{"row":178,"column":0},"action":"remove","lines":["  redirect_to @community",""],"id":118}],[{"start":{"row":176,"column":87},"end":{"row":177,"column":0},"action":"insert","lines":["",""],"id":119},{"start":{"row":177,"column":0},"end":{"row":177,"column":1},"action":"insert","lines":[" "]}],[{"start":{"row":177,"column":1},"end":{"row":177,"column":2},"action":"insert","lines":[" "],"id":120}],[{"start":{"row":177,"column":2},"end":{"row":180,"column":4},"action":"insert","lines":["  respond_to do |format|","   format.html { redirect_to  @community  }","   format.js { }"," end"],"id":121}],[{"start":{"row":180,"column":1},"end":{"row":180,"column":2},"action":"insert","lines":[" "],"id":122}],[{"start":{"row":180,"column":2},"end":{"row":180,"column":4},"action":"insert","lines":["  "],"id":123}],[{"start":{"row":178,"column":0},"end":{"row":178,"column":1},"action":"insert","lines":["#"],"id":125}],[{"start":{"row":179,"column":1},"end":{"row":179,"column":2},"action":"insert","lines":[" "],"id":126}],[{"start":{"row":179,"column":2},"end":{"row":179,"column":4},"action":"insert","lines":["  "],"id":127}],[{"start":{"row":178,"column":0},"end":{"row":178,"column":1},"action":"remove","lines":["#"],"id":128}],[{"start":{"row":178,"column":0},"end":{"row":178,"column":2},"action":"insert","lines":["  "],"id":129}],[{"start":{"row":179,"column":13},"end":{"row":179,"column":15},"action":"remove","lines":["js"],"id":159},{"start":{"row":179,"column":13},"end":{"row":179,"column":14},"action":"insert","lines":["a"]}],[{"start":{"row":179,"column":14},"end":{"row":179,"column":15},"action":"insert","lines":["l"],"id":159}],[{"start":{"row":179,"column":15},"end":{"row":179,"column":16},"action":"insert","lines":["l"],"id":160}],[{"start":{"row":178,"column":4},"end":{"row":178,"column":5},"action":"insert","lines":["#"],"id":161}],[{"start":{"row":144,"column":31},"end":{"row":145,"column":0},"action":"insert","lines":["",""],"id":162},{"start":{"row":145,"column":0},"end":{"row":145,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":145,"column":2},"end":{"row":145,"column":3},"action":"insert","lines":["@"],"id":163}],[{"start":{"row":145,"column":3},"end":{"row":145,"column":4},"action":"insert","lines":["u"],"id":164}],[{"start":{"row":145,"column":4},"end":{"row":145,"column":5},"action":"insert","lines":["s"],"id":165}],[{"start":{"row":145,"column":5},"end":{"row":145,"column":6},"action":"insert","lines":["e"],"id":166}],[{"start":{"row":145,"column":6},"end":{"row":145,"column":7},"action":"insert","lines":["r"],"id":167}],[{"start":{"row":145,"column":7},"end":{"row":145,"column":8},"action":"insert","lines":[" "],"id":168}],[{"start":{"row":145,"column":8},"end":{"row":145,"column":9},"action":"insert","lines":["="],"id":169}],[{"start":{"row":145,"column":9},"end":{"row":145,"column":10},"action":"insert","lines":[" "],"id":170}],[{"start":{"row":145,"column":10},"end":{"row":145,"column":11},"action":"insert","lines":["c"],"id":171}],[{"start":{"row":145,"column":11},"end":{"row":145,"column":12},"action":"insert","lines":["u"],"id":172}],[{"start":{"row":145,"column":10},"end":{"row":145,"column":12},"action":"remove","lines":["cu"],"id":173},{"start":{"row":145,"column":10},"end":{"row":145,"column":22},"action":"insert","lines":["current_user"]}],[{"start":{"row":1161,"column":0},"end":{"row":1162,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""],"id":174}],[{"start":{"row":1160,"column":0},"end":{"row":1161,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":175},{"start":{"row":1159,"column":0},"end":{"row":1160,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1159,"column":0},"end":{"row":1160,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":176},{"start":{"row":1158,"column":0},"end":{"row":1159,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1158,"column":0},"end":{"row":1159,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":177},{"start":{"row":1157,"column":0},"end":{"row":1158,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1157,"column":0},"end":{"row":1158,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":178},{"start":{"row":1156,"column":0},"end":{"row":1157,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1156,"column":0},"end":{"row":1157,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":179},{"start":{"row":1155,"column":0},"end":{"row":1156,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1155,"column":0},"end":{"row":1156,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":180},{"start":{"row":1154,"column":0},"end":{"row":1155,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1154,"column":0},"end":{"row":1155,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":181},{"start":{"row":1153,"column":0},"end":{"row":1154,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1153,"column":0},"end":{"row":1154,"column":0},"action":"remove","lines":["    unless params[:invite_everyone].nil?",""],"id":182},{"start":{"row":1152,"column":0},"end":{"row":1153,"column":0},"action":"insert","lines":["    unless params[:invite_everyone].nil?",""]}],[{"start":{"row":1161,"column":0},"end":{"row":1162,"column":0},"action":"insert","lines":["          end",""],"id":183}],[{"start":{"row":1161,"column":8},"end":{"row":1161,"column":10},"action":"remove","lines":["  "],"id":184}],[{"start":{"row":1161,"column":6},"end":{"row":1161,"column":8},"action":"remove","lines":["  "],"id":185}],[{"start":{"row":1161,"column":4},"end":{"row":1161,"column":6},"action":"remove","lines":["  "],"id":186}],[{"start":{"row":1152,"column":19},"end":{"row":1152,"column":34},"action":"remove","lines":["invite_everyone"],"id":187},{"start":{"row":1152,"column":19},"end":{"row":1152,"column":27},"action":"insert","lines":["user_ids"]}],[{"start":{"row":1444,"column":47},"end":{"row":1445,"column":0},"action":"insert","lines":["",""],"id":264},{"start":{"row":1445,"column":0},"end":{"row":1445,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":1445,"column":4},"end":{"row":1445,"column":36},"action":"insert","lines":["@all_users =  @group.user_groups"],"id":265}],[{"start":{"row":1440,"column":16},"end":{"row":1441,"column":0},"action":"insert","lines":["",""],"id":266},{"start":{"row":1441,"column":0},"end":{"row":1441,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":1441,"column":4},"end":{"row":1441,"column":5},"action":"insert","lines":["@"],"id":267}],[{"start":{"row":1441,"column":5},"end":{"row":1441,"column":6},"action":"insert","lines":["u"],"id":268}],[{"start":{"row":1441,"column":6},"end":{"row":1441,"column":7},"action":"insert","lines":["s"],"id":269}],[{"start":{"row":1441,"column":7},"end":{"row":1441,"column":8},"action":"insert","lines":["e"],"id":270}],[{"start":{"row":1441,"column":8},"end":{"row":1441,"column":9},"action":"insert","lines":["r"],"id":271}],[{"start":{"row":1441,"column":9},"end":{"row":1441,"column":10},"action":"insert","lines":[" "],"id":272}],[{"start":{"row":1441,"column":10},"end":{"row":1441,"column":11},"action":"insert","lines":["="],"id":273}],[{"start":{"row":1441,"column":11},"end":{"row":1441,"column":12},"action":"insert","lines":[" "],"id":274}],[{"start":{"row":1441,"column":12},"end":{"row":1441,"column":13},"action":"insert","lines":["c"],"id":275}],[{"start":{"row":1441,"column":13},"end":{"row":1441,"column":14},"action":"insert","lines":["u"],"id":276}],[{"start":{"row":1441,"column":14},"end":{"row":1441,"column":15},"action":"insert","lines":["r"],"id":277}],[{"start":{"row":1441,"column":12},"end":{"row":1441,"column":15},"action":"remove","lines":["cur"],"id":278},{"start":{"row":1441,"column":12},"end":{"row":1441,"column":24},"action":"insert","lines":["current_user"]}],[{"start":{"row":1443,"column":4},"end":{"row":1447,"column":103},"action":"remove","lines":["@inv_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,false).collect(&:user_id)])","    @ad_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,true).collect(&:user_id)])","    @is_admin = @ad_users.include? current_user","    @all_users =  @group.user_groups","    @ucs = @group.user_groups.where(\"group_id = ? AND invitation = ?\",params[:grp_id], Uc_enum::JOINED)"],"id":279},{"start":{"row":1443,"column":4},"end":{"row":1447,"column":89},"action":"insert","lines":[" @mem_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,false).collect(&:user_id)])","    @ad_users = User.where(['id IN (?)', @group.user_groups.where('invitation = ? AND is_admin = ?',Uc_enum::JOINED,true).collect(&:user_id)])","    @all_users =  @group.user_groups.where('invitation = ? ',Uc_enum::JOINED)","    @is_admin = @ad_users.include? current_user","    @ucs = @group.user_groups.where(\"user_id = ?  AND is_admin=?\",current_user.id, true )"]}],[{"start":{"row":1443,"column":4},"end":{"row":1443,"column":5},"action":"remove","lines":[" "],"id":280}]]},"ace":{"folds":[],"scrolltop":11027.5,"scrollleft":0,"selection":{"start":{"row":853,"column":28},"end":{"row":853,"column":28},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":786,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1436942665000,"hash":"beabdfba5cceb549650d395f88c9c054dddfde75"}