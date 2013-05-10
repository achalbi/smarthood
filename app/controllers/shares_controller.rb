class SharesController < ApplicationController
  def new
  	@album = Album.find(params[:id])
  	@email = params[:email]
  	UserMailer.share_album(current_user,@email,@album)
  end

  def show
  end
end
