class EventsController < ApplicationController
	helper_method :sort_column, :sort_direction

  def new
    @group_ids = nil
    @user_ids = nil
    @editor_group_ids = nil
    @editor_user_ids = nil
  	@event = Event.new
    if !params[:p_invite_groups].nil?
       @group_ids = params[:p_invite_groups].keys.collect(&:to_i)
    end
    if !params[:p_invite_users].nil?
       @user_ids = params[:p_invite_users].keys.collect(&:to_i)
    end
    if !params[:p_editor_groups].nil?
       @editor_group_ids = params[:p_editor_groups].keys.collect(&:to_i)
    end
    if !params[:p_editor_users].nil?
       @editor_user_ids = params[:p_editor_users].keys.collect(&:to_i)
    end
    	@invite_groups = Group.search(params[:search1], @group_ids).order(sort_column(params[:sort1]) + ' ' + sort_direction(params[:direction1]))  
    	@editor_groups = Group.search(params[:search2], @editor_group_ids).order(sort_column(params[:sort2]) + ' ' + sort_direction(params[:direction2]))  
      @invite_users = User.search(params[:search3], @user_ids).order(sort_column(params[:sort3]) + ' ' + sort_direction(params[:direction3]))   
      @editor_users = User.search(params[:search4], @editor_user_ids).order(sort_column(params[:sort4]) + ' ' + sort_direction(params[:direction4]))  
      

    respond_to do |format|
      format.html {render layout: "app_full"}
      if !@group_ids.nil?
        format.js {render partial: "inv_gp"}
      elsif !@user_ids.nil?
        format.js {render partial: "inv_usr"}
      elsif !@editor_group_ids.nil?
        format.js {render partial: "ed_gp"}
      elsif !@editor_user_ids.nil?
        format.js {render partial: "ed_usr"}
      end
    end

  end

   	def create
      @event = current_user.events.build(params[:event])
     
        if !params[:invite_groups].nil?
          @invited_groups = Group.find(params[:invite_groups].keys.collect(&:to_i))  
        end
        if !params[:editor_groups].nil?
          @editor_groups = Group.find(params[:editor_groups].keys.collect(&:to_i))
        end
        if !params[:invite_users].nil?
        @invited_users = User.find(params[:invite_users].keys.collect(&:to_i))
        end
        if !params[:editor_users].nil?
        @editor_users = User.find(params[:editor_users].keys.collect(&:to_i))
        end

        if @event.save
          if !@invited_groups.nil?
            @invited_groups.each do |invited_group|
              @event.invited_groups << invited_group
            end
          end
          if !@invited_users.nil?
            @invited_users.each do |invited_user|
              @event.invited_users << invited_user
            end
          end
          if !@editor_groups.nil?
            @editor_groups.each do |editor_group|
              @event.editor_groups << editor_group
            end
          end
          if !@editor_users.nil?
            @editor_users.each do |editor_user|
              @event.editor_users << editor_user
            end
          end  

        end
        @event.save
        flash[:success] = "Event successfully created!"

        redirect_to root_url
    end

    def index
      @events = Event.paginate(page: params[:page], :per_page => 8)
    end

    def show
    @event = Event.find(params[:id])
    @evt = Event.find(params[:id])
    @activities = @evt.activities
    @group_ids = nil
    @user_ids = nil
    @editor_group_ids = nil
    @editor_user_ids = nil
    if !params[:p_invite_groups].nil?
       @group_ids = params[:p_invite_groups].keys.collect(&:to_i)
    end
    if !params[:p_invite_users].nil?
       @user_ids = params[:p_invite_users].keys.collect(&:to_i)
    end
    if !params[:p_editor_groups].nil?
       @editor_group_ids = params[:p_editor_groups].keys.collect(&:to_i)
    end
    if !params[:p_editor_users].nil?
       @editor_user_ids = params[:p_editor_users].keys.collect(&:to_i)
    end
  @invite_groups = Group.search(params[:search1], @group_ids).order(sort_column(params[:sort1]) + ' ' + sort_direction(params[:direction1]))  
  @editor_groups = Group.search(params[:search2], @editor_group_ids).order(sort_column(params[:sort2]) + ' ' + sort_direction(params[:direction2]))  
  @invite_users = User.search(params[:search3], @user_ids).order(sort_column(params[:sort3]) + ' ' + sort_direction(params[:direction3]))   
  @editor_users = User.search(params[:search4], @editor_user_ids).order(sort_column(params[:sort4]) + ' ' + sort_direction(params[:direction4]))  

  @event_inv_gp = @event.invited_groups.pluck(:group_id)
  @event_ed_gp = @event.editor_groups.pluck(:group_id)
  @event_inv_usr = @event.invited_users.pluck(:user_id)
  @event_ed_usr = @event.editor_users.pluck(:user_id)

 end

  private
  def sort_column(sort)
	Group.column_names.include?(sort) ? sort : "name"
  end  
    
  def sort_direction(direction)
     %w[asc desc].include?(direction) ?  direction : "asc"   
  end  
end
