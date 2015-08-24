class SConcernsController < ApplicationController
  # GET /s_concerns
  # GET /s_concerns.json
  def index
    @community = active_community
    @user = current_user
    #@post_ids = Communitypost.where('community_id = ?', @community).collect(&:post_id)
    #@posts  = Post.where('postable_type = ? and id IN (?) ', Objecttypeenum::SCONCERN, @post_ids).order('updated_at DESC').paginate(:page => params[:page], :per_page => 4)    
    @posts  = @community.posts.where('postable_type = ?', Objecttypeenum::SCONCERN).order('updated_at DESC').paginate(:page => params[:page], :per_page => 4)    
    
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @s_concerns }
    end
  end
  
    def next_page
    @community = active_community
    @posts  = @community.posts.where('postable_type = ?', Objecttypeenum::SCONCERN).order('updated_at DESC').paginate(:page => params[:page], :per_page => 4)    
    
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @s_concerns }
    end
  end

  # GET /s_concerns/1
  # GET /s_concerns/1.json
  def show
    @s_concern = SConcern.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @s_concern }
    end
  end

  # GET /s_concerns/new
  # GET /s_concerns/new.json
  def new
    @s_concern = SConcern.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @s_concern }
    end
  end

  # GET /s_concerns/1/edit
  def edit
    @s_concern = SConcern.find(params[:id])
  end

  # POST /s_concerns
  # POST /s_concerns.json
  def create
    @s_concern = SConcern.new(params[:s_concern])
    @s_concern.save
#    @community = active_community
#    @user = current_user

    unless params[:photo].nil?
      album = Album.create(:description => "album_sconcern", :privacy => Privacyenum::PRIVATE , :title => "album_sconcern_"+@s_concern.id.to_s , :user_id => current_user.id )
      album.save
      album.photos << current_user.photos.build(params[:photo])
       @s_concern.albums << album
    end
    
    content = Sanitize.clean("<h3 class='mt0'>"+@s_concern.content+"</h3>", Sanitize::Config::RELAXED)
    @post = @s_concern.build_post(content: content)
    @post.title = "<b class='text-default'> has raised a concern</b>"
    @post.communities << active_community
    @post.user = current_user
    @post.save
    
    unless params[:photo].nil?
      redirect_to :action => "create_post", id: @s_concern.id
    end
    
    respond_to do |format|
       # format.html { redirect_to s_concerns_url, notice: 'S concern was successfully created.' }
        format.html {  }
        format.js {}
        format.json { render json: @s_concern, status: :created, location: @s_concern }
    end
  end

  # PUT /s_concerns/1
  # PUT /s_concerns/1.json
  def update
    @s_concern = SConcern.find(params[:id])
    @post = Post.find_by_post_type(@s_concern)[0]
    @s_concern.update_attributes(params[:s_concern])
    unless @post.content == @s_concern.content
      content = Sanitize.clean("<h3 class='mt0'>"+@s_concern.content+"</h3>", Sanitize::Config::RELAXED)
      @post.content = content
      @post.save
    end
    
    unless params[:photo].nil?
      if  @s_concern.albums.blank?
        album = Album.create(:description => "album_sconcern", :privacy => Privacyenum::PRIVATE , :title => "album_sconcern_"+@s_concern.id.to_s , :user_id => current_user.id )
        album.save
        album.photos << current_user.photos.build(params[:photo])
         @s_concern.albums << album
      else
        album = @s_concern.albums[0]
        photo = album.photos[0]
        photo.remove_pic!
        photo.destroy
        album.photos << current_user.photos.build(params[:photo])
      end
    end
    
    unless params[:photo].nil?
      redirect_to :action => "show_post", id: params[:id]
    end

    respond_to do |format|
        format.js { }
        format.json { head :no_content }
    end
  end
  
  def create_post
    @s_concern = SConcern.find(params[:id])
    @post = Post.find_by_post_type(@s_concern)[0]
    
    respond_to do |format|
        format.html { render :layout => false }
        format.json { head :no_content }
    end
  end
  
  def show_post
    @s_concern = SConcern.find(params[:id])
    @post = Post.find_by_post_type(@s_concern)[0]
    
    respond_to do |format|
        format.html { render :layout => false }
        format.json { head :no_content }
    end
  end

  # DELETE /s_concerns/1
  # DELETE /s_concerns/1.json
  def destroy
    @s_concern = SConcern.find(params[:id])
    @s_concern.destroy

    respond_to do |format|
      format.html { redirect_to s_concerns_url }
      format.json { head :no_content }
    end
  end
end
