class GroupsController < ApplicationController
before_filter :signed_in_user, only: [:create, :destroy]
	
  def new
  	@group = Group.new
  end
  def index

  	@groups = Group.paginate(page: params[:page], :per_page => 8)
  end

  def create
    @group = current_user.groups.build(params[:group])
    @group.User = current_user
    if @group.save
      flash[:success] = "Group created!"
      @group.follow!(current_user, @group.id)
      redirect_to :action => :index
    else
    	flash[:error] = "Group not created!"
        redirect_to :action => :index
    end 

    end

    def show
    @group = Group.find(params[:id])
    @posts = @group.posts.paginate(page: params[:page], :per_page => 8)
    @user = current_user
    end

    def followers
    @title = "Followers"
    @group = Group.find(params[:id])
    @users = @group.users.paginate(page: params[:page], :per_page => 8)
    render 'show_follow'
  end

end
