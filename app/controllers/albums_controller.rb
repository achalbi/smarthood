class AlbumsController < ApplicationController
  def new
  end

  def create
    unless params[:photo].nil?
         @photos = Photo.find(params[:photo].keys.collect(&:to_i))  
          @album = current_user.albums.build(params[:album])
          # @album.user = current_user
          @album.save
          @photos.each do |photo|
            @album.photos << photo
          end
          flash[:success] = "Album created"
    else
      flash[:notice] = "Please select atleast 1 photo..."
      
    end
   
      respond_to do |format|
         format.html {  }
         format.js {render  :locals => { :album => @album, :album_list => @album }  }
      end
  end

  def destroy
    @camera_roll = current_user.photos.order('created_at DESC').all
    @album = Album.find(params[:id])
     @title = @album.title
     Album.find(params[:id]).destroy
    flash[:success] = "Album: "+@title+" destroyed!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :album => @camera_roll } }
      end
  end

  def show
    @album = Album.find(params[:id])
       respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :album => @album } }
      end
  end

  def index
  	@camera_roll = current_user.photos.order('created_at DESC').all
  	@albums = current_user.albums.all
    @album = Album.new
     respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :album => @camera_roll } }
      end
  end

  def list
    @albums = current_user.albums.all
    @album = Album.new
     respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :albums => @albums } }
      end
  end

  
def edit
    @album = Album.find(params[:id])
    @photos = Photo.find(params[:photo_chk].keys.collect(&:to_i)) 
       @photos.each do  |photo|
           @album.photoalbums.where(photo_id: photo.id)[0].destroy       
       end
   if @album.update_attributes(params[:album])
    flash[:success] = "Album updated successfully!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :album => @album } }
      end
   end
  end


end
