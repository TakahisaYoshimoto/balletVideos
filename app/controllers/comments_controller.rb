class CommentsController < ApplicationController
  def create
    unless current_user.nil?
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id
      @comment.save
    end
    redirect_to youtube_video_path(@comment.youtube_video_id)
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :youtube_video_id)
    end
end
