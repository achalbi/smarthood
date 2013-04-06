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
         format.js {render  :locals => { :album => @album }  }
      end
  end

  def update
  end

  def destroy
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
end
