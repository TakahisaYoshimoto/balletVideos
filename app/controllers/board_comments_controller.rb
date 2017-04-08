class BoardCommentsController < ApplicationController
  before_action :set_board_comment, only: [:destroy]

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

  def destroy
    redirect_to root_path and return if user_level_check(2)
    @board_comment.destroy
    redirect_to board_path(@board_comment.board.id)
  end

  private
    def set_board_comment
      @board_comment = BoardComment.find(params[:id])
    end

    def board_comment_params
      params.require(:board_comment).permit(:text, :board_id)
    end
end
