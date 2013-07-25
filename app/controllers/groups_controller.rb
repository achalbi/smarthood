class GroupsController < ApplicationController
include PhotosHelper, GroupsHelper
before_filter :signed_in_user, only: [:create, :destroy]
	
  def new
  	@group = Group.new
  end
  def index
    @group = Group.new
   # @groups = Group.where(:id => current_user.user_groups.collect(&:group_id)) 
    @groups = active_community_user_groups
    @public_groups = Group.where(['id  NOT IN (?) AND privacy  = ?' , current_user.user_groups.collect(&:group_id), false]) 
    @private_groups = Group.where(['id  NOT IN (?) AND privacy  = ?' , current_user.user_groups.collect(&:group_id), true])
  end

  def create
    @group = current_user.groups.build(params[:group])
    @group.User = current_user
    if @group.photo.nil?
     @group.photo = defaultPhoto('new_group')
    end
    @group.community_id = active_community.id
    if @group.save
      flash[:success] = "Group created!"
      @group.follow!(current_user, @group.id)
      # redirect_to :action => :index
    else
    	flash[:error] = "Group not created!"
       # redirect_to :action => :index
    end 
      respond_to do |format|
         format.html { redirect_to :action => :index   }
         format.js {redirect_to :action => :index, format: 'js'  }
      end
    end

    def show
    @group = Group.find(params[:id])
    @posts = @group.posts.paginate(page: params[:page], :per_page => 8)
    @user = current_user
    @users = @group.users
      respond_to do |format|
         format.html {  }
         format.js {render  :locals => { :group => @group, :posts => @posts, :user => @user }  }
      end
    end

    def followers
    @title = "Followers"
    @group = Group.find(params[:id])
    @users = @group.users.paginate(page: params[:page], :per_page => 8)
    render 'show_follow'
  end

  private  
  def sort_column  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end  
    
  def sort_direction  
     %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"   
  end  

end
