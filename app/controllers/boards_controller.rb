class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit]

  def index
    @boards = Board.all
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
  end

  def create
    unless user_signed_in?
      redirect_to root_path
    end

    @board = Board.new(board_params)
    @board.user_id = current_user.id

    if @board.save
      redirect_to @board
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
end
