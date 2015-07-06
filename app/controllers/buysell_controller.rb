class BuysellController < ApplicationController
  def new
  end

  def index
  	@comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).pluck(:community_id)
    @comm_id << active_community.id
    @joined_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)])
    @selected_comm = []
    @selected_comm << active_community
    @posts  = Post.where('postable_type = ? ', Objecttypeenum::BUYSELLITEM).order('updated_at DESC') #.paginate(:page => params[:page], :per_page => 4)
=begin
    @items = BuysellItem.all
    @posts = []
    @items.each do |item|
      item.posts.each do |post|
        @posts << post
      end
    end
    @posts = @posts.reverse
=end

    @category = BuysellItemCategory.new
    @subcategory = BuysellItemSubcategory.new
    @subcategories = []
    @buysellitem = BuysellItem.new
    @buysellitem.address = Address.new
    unless current_user.address.nil?
      @buysellitem.address.attributes = current_user.address.attributes.except("id", "created_at", "updated_at")
    end
    @buysellitem.contact_no = current_user.user_info.mobile
  end

  
  def add_category
  	@category = BuysellItemCategory.create(params[:buysell_item_category])
  	@category.save

    @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
    @comm_id << active_community.id
    @joined_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)])
    @selected_comm = []
    @selected_comm << active_community
    @items = current_user.buysell_items.all
    @category = BuysellItemCategory.new
    @subcategory = BuysellItemSubcategory.new

  end

  def add_subcategory
  	@subcategory = BuysellItemSubcategory.create(params[:buysell_item_subcategory])
    @category = BuysellItemCategory.find(params[:buysell_item_subcategory][:buysell_item_category_id])
    @subcategory.buysell_item_category = @category
    @subcategory.save
  	
    @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
    @comm_id << active_community.id
    @joined_communities = Community.where(['id IN (?)', current_user.communities.collect(&:id)])
    @selected_comm = []
    @selected_comm << active_community
    @items = current_user.buysell_items.all
    @category = BuysellItemCategory.new
    @subcategory = BuysellItemSubcategory.new
  end

  def load_subcategory
    @subcategories = []
    unless params[:category_id].blank?
        @category = BuysellItemCategory.find(params[:category_id])
        @subcategories = @category.buysell_item_subcategories
    end
  end

  def edit_subcategory
    @subcategories = []
    unless params[:category_id].blank?
        @category = BuysellItemCategory.find(params[:category_id])
        @subcategories = @category.buysell_item_subcategories
    end
  end

  def create
    @buysellitem = current_user.buysell_items.build(params[:buysell_item])
    @buysellitem.buysell_item_subcategory_id = params[:buysell_item_subcategory][:id]
    @buysellitem.buysell_item_category_id = params[:buysell_item_category][:id2]
    @buysellitem.save
        params[:photos][:pic].each do |pic|
          @photo = Photo.new
            @photo.pic = pic
            @buysellitem.photos << @photo
        end    
    @buysellitem.save
        @post = Post.new
        @post.title = "Item: '" + @buysellitem.name << "' was posted by '" << current_user.name << "' to " << @buysellitem.item_type << " at " << @buysellitem.currency << " " << @buysellitem.price.to_s << ". " 
        @post.content = ""
        @post.user_id = current_user.id
        @post.postable = @buysellitem
        @post.save
    if @buysellitem.privacy == Privacyenum::PRIVATE
    end
      params[:search][:community_id].each do |comm_id|
        @community = Community.find(comm_id)
        @post.communities << @community 
        @buysellitem.communities << @community 
      end
        @buysellitem.photos.each do |photo|
          @post.photos << photo
        end
    @buysellitem.save
    @buysellitem

#        getNotifiableUsers(Objecttypeenum::BUYSELL, @buysellitem, nil, nil, Uc_enum::CREATED)

  end

  def search_items
    @items = BuysellItem
      if(params[:item_type] != 'all')
        @items = @items.where(item_type: params[:item_type])
      end
      if(params[:condition] != 'all')
        @items = @items.where(condition: params[:condition]) 
      end
      if(params[:comm_type] != 'all')
        @items = @items.joins(:communities).where(communities: {id: params[:search][:community_id]}) 
      end
      unless params[:buysell_item_category][:id1].blank?
        @items = @items.where(buysell_item_category_id: params[:buysell_item_category][:id1])
        unless params[:buysell_item_subcategory][:id].blank?
          @items = @items.where(buysell_item_subcategory_id: params[:buysell_item_subcategory][:id])
        end
      end
      unless params[:price_from].blank?
        @items = @items.where("price >= ?", params[:price_from]) 
      end
      unless params[:price_to].blank?
        @items = @items.where("price <= ?", params[:price_to]) 
      end
      @items = @items.paginate(:page => params[:page], :per_page => 4)

    @posts = []
    @items.each do |item|
      item.posts.each do |post|
        @posts << post
      end
    end
    @posts = @posts.reverse
  end


  def update
    @item = BuysellItem.find(params[:buysell_item][:id])
    @item.update_attributes(params[:buysell_item])
    @item.save
  end

  def delete_item
    @post = Post.find(params[:id])
    @item = @post.postable
    @post.destroy
    @item.destroy
  end

  def buysell_posts_page
    @posts  = Post.where('postable_type = ? ', Objecttypeenum::BUYSELLITEM).order('updated_at DESC').paginate(:page => params[:page], :per_page => 4)
  end

end
