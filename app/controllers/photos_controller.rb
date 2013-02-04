class PhotosController < ApplicationController
  
  before_filter :signed_in_user, only: [:create, :destroy]

  before_filter :find_post
  before_filter :find_or_build_photo
  
  def new 
  end
  def index
  end
  
  def create
    respond_to do |format|
      unless @photo.save
        flash[:error] = 'Photo could not be uploaded'
      end
      format.js do
        render :text => render_to_string(:partial => 'photos/photo', :locals => {:photo => @photo})
      end
    end
  end
 
  def destroy
    respond_to do |format|
      unless @photo.destroy
        flash[:error] = 'Photo could not be deleted'
      end
      format.js
    end
  end
 
  private
    
    def find_post
      @post = current_user.posts.find(params[:post_id])
      raise ActiveRecord::RecordNotFound unless @post
    end
    
    def find_or_build_photo
      @photo = params[:id] ? @post.photos.find(params[:id]) : @post.photos.build(params[:photo])
    end
 
end