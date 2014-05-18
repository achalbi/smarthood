class PhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  before_filter :find_post, :except => [:index]
  before_filter :find_or_build_photo, :except => [:index]
  
  def new 
  end
  
  def index
    @photos = current_user.photos.order("DATE(created_at) DESC").all
    @camera_roll = @photos.group_by { |t| t.created_at.beginning_of_month }  
    @photo = Photo.new
    @albums = current_user.albums.all
    @album = Album.new
  end
  
  def create
    respond_to do |format|
      unless @photo.save
        flash[:error] = 'Photo could not be uploaded'
      end
      format.html { redirect_to photos_path }
      format.js do
        render :text => render_to_string(:partial => 'photos/photo', :locals => {:photo => @photo})
      end
    end
  end
 
  def destroy
    @photo = Photo.find(params[:id])
    @photo.remove_pic!
    Photo.find(params[:id]).destroy
    respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
   end
  end

    def updates
    @album = Album.find(params[:album].keys.collect(&:to_i))[0]
    @photos = Photo.find(params[:photo1].keys.collect(&:to_i)) 
       @photos.each do  |photo|
           @album.photos << photo    
       end
    flash[:success] = "Album updated successfully!"
    redirect_to :controller=>'albums', :action => 'index'
  end
 
  def delete_photos
      @photos = Photo.find(params[:photo2].keys.collect(&:to_i)) 
      @photos.each do  |photo|
           photo.remove_pic!
           photo.destroy     
       end
       @camera_roll = current_user.photos.order('created_at DESC').all
       redirect_to :controller=>'albums', :action => 'index'
       
  end


  private
    
    def find_post
      if params[:type] == 'post'
        @post = current_user.posts.find(params[:post_id])
        raise ActiveRecord::RecordNotFound unless @post
      end
    end
    
    def find_or_build_photo
      if params[:type] == 'post'
        @photo = params[:id] ? @post.photos.find(params[:id]) : @post.photos.build(params[:photo])
      end
      if params[:type] == 'user'
       # @photo = params[:id] ? current_user.photos.find(params[:id]) : current_user.photos.build(params[:photo][:photo])
        # logger.info params[:photo][:photos][:pic]
         params[:photo][:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            current_user.photos << @photo
        end

      end
    end
 
end