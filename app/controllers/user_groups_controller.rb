class UserGroupsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user_group = current_user.user_groups.find_by_group_id(params[:user_group][:group_id])
    @group = Group.find(params[:user_group][:group_id])
    
    @group.follow!(current_user, params[:user_group][:group_id])
    respond_to do |format|
            format.html { redirect_to 'groups/index' }
            format.js { render  :locals => { :group => @group } }
    end
  end

  def destroy
   @user_group = current_user.user_groups.find(params[:id])
   @group = Group.find(@user_group.group_id)
    flash[:success] = @group.name
    @user_group.unfollow!(current_user, params[:id])
    respond_to do |format|
      format.html { redirect_to 'groups/index' }
      format.js  { render  :locals => { :group => @group } }
    end
  end
end