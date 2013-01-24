class GroupsController < ApplicationController
  def new
  end
  def index
  	@groups = Group.paginate(page: params[:page], :per_page => 10)
  end
end
