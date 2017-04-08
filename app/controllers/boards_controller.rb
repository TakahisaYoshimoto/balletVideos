class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit]

  def index
    @boards = Board.all.order('created_at desc').includes(:user)
  end

  def show
    @board_comment = BoardComment.new
    @board_comments = BoardComment.where(board_id: @board.id).order('created_at asc').includes(:user)
  end

  def new
    unless user_signed_in?
      redirect_to root_path
    end

    @board = Board.new
    @board_comment = BoardComment.new
    @board.board_tags.build
  end

  def create
    unless user_signed_in?
      redirect_to root_path
    end

    ActiveRecord::Base.transaction do
      @board = Board.new(board_params)
      @board.user_id = current_user.id
      if @board.save
        @board_comment = BoardComment.new(board_comment_params)
        @board_comment.user_id = current_user.id
        @board_comment.board_id = @board.id
        unless @board_comment.save
          raise
        end
      else
        @board_comment = BoardComment.new(board_comment_params)
        raise
      end
    end
      redirect_to @board
    rescue => e
      render 'new'
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
      params.require(:board).permit(:title, :category,
        board_tags_attributes: [:id, :name, :_destroy])
    end

    def board_comment_params
      params.require(:board_comment).permit(:text)
    end
end
