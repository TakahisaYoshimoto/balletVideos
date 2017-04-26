class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :destroy]

  def index
    @boards = Board.all.order('created_at desc').page(params[:page]).includes(:user)
  end

  def Search
    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp.chop! if sp[sp.length-1] == " "#最後の文字がスペースだったら削除
    sp = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    sp = '%'+sp+'%'
    sp = sp.split(",")#ひとつの文字列だったspをカンマで区切って配列にする
    ph_title = "title like ?"
    c = sp.length-1
    c.times{ ph_title += " AND title like ?" } if sp.length > 1

    @boards = Board.where("#{ph_title}", *sp)
      .page(params[:page])
      .order(created_at: :desc)
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

  def destroy
    redirect_to root_path and return if user_level_check(2)
    @board.destroy
    redirect_to boards_path
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
