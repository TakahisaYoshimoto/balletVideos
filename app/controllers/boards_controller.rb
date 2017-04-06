class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit]

  def index
    @boards = Board.all.order('created_at desc')
  end

  def show
    @board_comment = BoardComment.new
    @board_comments = BoardComment.where(board_id: @board.id).order('created_at asc')
  end

  def new
    unless user_signed_in?
      redirect_to root_path
    end

    @board = Board.new
    @board_comment = BoardComment.new
  end

  def create
    unless user_signed_in?
      redirect_to root_path
    end

    @board = Board.new(board_params)
    @board.user_id = current_user.id

    if @board.save
      @board_comment = BoardComment.new(board_comment_params)
      @board_comment.user_id = current_user.id
      @board_comment.board_id = @board.id
      if @board_comment.save
        redirect_to @board
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def edit
  end

  def comment_create
    
  end

  private
    def set_board
      @board = Board.find(params[:id])
    end

    def board_params
      params.require(:board).permit(:title, :category)
    end

    def board_comment_params
      params.require(:board_comment).permit(:text)
    end
end
