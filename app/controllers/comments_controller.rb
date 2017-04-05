class CommentsController < ApplicationController
  def create
    unless current_user.nil?
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id
      @comment.save
    end
    redirect_to youtube_video_path(@comment.youtube_video_id)
  end

  def reply
    unless current_user.nil?
      @comment = Comment.new
      @comment.user_id = current_user.id
      @comment.reply = params[:reply_params][:comment_id].to_i
      @comment.text = params[:text]
      @comment.youtube_video_id = params[:reply_params][:youtube_video_id].to_i
      @comment.save
    end
    redirect_to youtube_video_path(params[:reply_params][:youtube_video_id].to_i)
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :youtube_video_id)
    end
end
