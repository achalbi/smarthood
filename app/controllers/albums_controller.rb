class AlbumsController < ApplicationController
  include ActivitynotificationsHelper

  def new
    @album = Album.new
  end

  def create
    
        @album = current_user.albums.build(params[:album])
          # @album.user = current_user
        @share = Share.new
        @album.save
        params[:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @album.photos << @photo
        end
        @album.save
      if @album.privacy == Privacyenum::PUBLIC
        @post = Post.new
        @post.content = "New album: '" + @album.title << "' was created by '" << current_user.name << "'. " 
        @post.user_id = current_user.id
        @post.postable = @album
        @post.save
        @post.communities << active_community 
        @album.photos.each do |photo|
          @post.photos << photo
        end
      end
        body_text = "The Album '" + @album.title + "' was created by "+ current_user.name
        href = "/albums/"+ @album.id.to_s

        getNotifiableUsers(Objecttypeenum::ALBUM, @album, @album.albumable_type, @album.albumable_id, Uc_enum::CREATED)

    
      respond_to do |format|
         format.html {  }
         format.js {  }
      end
  end
=begin
  def create_from_photos
    unless params[:photo].nil?
         @photos = Photo.find(params[:photo].keys.collect(&:to_i))  
          @album = current_user.albums.build(params[:album])
          # @album.user = current_user
          @share = Share.new
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
         format.js {  }
      end
  end
=end
  def destroy
    @camera_roll = current_user.photos.order('created_at DESC').all
    @album = Album.find(params[:id])
     @title = @album.title
     Album.find(params[:id]).destroy
    @camera_roll = @camera_roll.group_by { |t| t.created_at.beginning_of_month }  
    @albums = current_user.albums.all
    @album = Album.new
    #flash[:success] = "Album: "+@title+" destroyed!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :album => @camera_roll } }
      end
  end

  def show
    @album = Album.find(params[:id])
    @share = Share.new
       respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :album => @album } }
      end
  end

  def index
  	@camera_roll = current_user.photos.order('created_at DESC').all
  	@albums = current_user.albums.all.reverse
    @album = Album.new
     respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :album => @camera_roll } }
      end
  end

  def list
    @albums = current_user.albums.all.reverse
    @album = Album.new
     respond_to do |format|
         format.html {  }
         format.js { render  :locals => { :albums => @albums } }
      end
  end

  
def edit
    @album = Album.find(params[:id])
    @share = Share.new
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

  def delete_photos
      @photos = Photo.find(params[:photo2].keys.collect(&:to_i)) 
      @photos.each do  |photo|
           photo.destroy     
       end
       @camera_roll = current_user.photos.order('created_at DESC').all
       redirect_to :controller=>'albums', :action => 'index'
       
  end

end
