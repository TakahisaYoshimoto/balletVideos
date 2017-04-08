class BoardCommentsController < ApplicationController
  def create
    if user_signed_in?
      @board_comment = BoardComment.new(board_comment_params)
      @board_comment.user_id = current_user.id
      if @board_comment.save
        redirect_to board_path(@board_comment.board_id) and return
      else
        @board = Board.find(@board_comment.board_id)
        render 'new'
      end
    end
    #redirect_to board_path(@board_comment.board_id) and return
  end

  private
    def board_comment_params
      params.require(:board_comment).permit(:text, :board_id)
    end
end
