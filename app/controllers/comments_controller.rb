class CommentsController < ApplicationController
  def new
  end

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save
    flash[:success] = "Comments created!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :post => @post } }
      end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = Post.find(@comment.post_id)
     Comment.find(params[:id]).destroy
    flash[:success] = "Comments destroyed!"
    respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render  :locals => { :post => @post } }
      end
  end
end
