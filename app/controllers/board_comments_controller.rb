class BoardCommentsController < ApplicationController
  before_action :set_board_comment, only: [:edit, :update, :destroy]

  def create
    if user_signed_in?
      @board_comment = BoardComment.new(board_comment_params)
      @board_comment.user_id = current_user.id
      if @board_comment.save
        #トークルーム製作者のnotice_emailがtrueだったらコメントしたよってメールする
        if @board_comment.board.user.notice_email
          @mail = SupportMailer.sendmail_board_commented_after(@board_comment.board_id,
            @board_comment.text,
            @board_comment.user.username)
            .deliver
        end

        redirect_to board_path(@board_comment.board_id) and return
      else
        @board = Board.find(@board_comment.board_id)
        render 'new'
      end
    end
    #redirect_to board_path(@board_comment.board_id) and return
  end

  def edit
  end

  def update
    if @board_comment.update(board_comment_params)
      redirect_to board_path(@board_comment.board_id)
    else
      render 'edit'
    end 
  end

  def destroy
    redirect_to root_path and return if user_level_check(2)
    @board_comment.display = false
    @board_comment.save
    redirect_to board_path(@board_comment.board.id)
  end

  def display
    redirect_to root_path and return if user_level_check(2)
    @board_comment = BoardComment.find(params[:format])
    @board_comment.display = true
    @board_comment.save
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
