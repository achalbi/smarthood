class GroupsController < ApplicationController
before_filter :signed_in_user, only: [:create, :destroy]
	
  def new
  	@group = Group.new
  end
  def index

  	@groups = Group.paginate(page: params[:page], :per_page => 10)
 	
  end

  def create
    @group = current_user.groups.build(params[:group])
    @group.User = current_user
    if @group.save
      flash[:success] = "Group created!"
      redirect_to :action => :index
    else
    	flash[:error] = "Group not created!"
        redirect_to :action => :index
    end 

    end
end
