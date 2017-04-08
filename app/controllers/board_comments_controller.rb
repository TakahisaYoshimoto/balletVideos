class BoardCommentsController < ApplicationController
  def create
    if user_signed_in?
      @board_comment = BoardComment.new(board_comment_params)
      @board_comment.user_id = current_user.id
      @board_comment.save
    end
    redirect_to board_path(@board_comment.board_id) and return
  end

  private
    def board_comment_params
      params.require(:board_comment).permit(:text, :board_id)
    end
end
