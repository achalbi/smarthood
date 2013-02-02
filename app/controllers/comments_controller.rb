class CommentsController < ApplicationController
  def new
  end

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save
    flash[:success] = "Comments created!"
    redirect_to root_path
  end

  def destroy
     Comment.find(params[:id]).destroy
    flash[:success] = "Comments destroyed!"
    redirect_to root_path
  end
end
