class PostCommentsController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
  end
  def create
  	post = Post.find(params[:post_id])
  	comment = PostComment.new(post_comment_params)
  	comment.user_id = current_user.id
  	comment.post_id = post.id
  	comment.save
  	redirect_to post_path(post.id)
  end

  def destroy
  	@post = Post.find(params[:post_id])
  	post_comment = @post.post_comments.find(params[:id])
  	post_comment.destroy
  	redirect_to request.referrer
  end

  private
  def post_comment_params
  	params.require(:post_comment).permit(:comment)
  end
end
