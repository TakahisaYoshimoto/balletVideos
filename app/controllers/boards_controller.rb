class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :destroy, :like]

  def index
    @attention_boards = Board.all
      .order('board_comments_count desc')
      .limit(6)
      .offset(0)
      .includes(:user)
      .includes(:board_tags)
    @boards = Board.all.order('created_at desc').limit(9).offset(0).includes(:user).includes(:board_tags)
    @top_img_text_a = SiteConfiguration.find_by(item: 'board_top_img_text_a')
    @top_img_text_b = SiteConfiguration.find_by(item: 'board_top_img_text_b')
  end

  def new_lists
    @boards = Board.all.order('created_at desc').page(params[:page]).per(24).includes(:user).includes(:board_tags)
    render '/boards/lists'
  end

  def Search
    sp = params[:search_params].gsub("　"," ")#全角スペースを半角スペースに変換
    sp.chop! if sp[sp.length-1] == " "#最後の文字がスペースだったら削除
    sp = sp.gsub(" ","%,%")#半角スペースをカンマに変換(プレスホルダーの第二引数以降に使用する変数spに代入)
    sp = '%'+sp+'%'
    sp = sp.split(",")#ひとつの文字列だったspをカンマで区切って配列にする

    @boards = Board.joins(:board_tags)
      .page(params[:page])
      .order(created_at: :desc)
      .distinct

    sp.each do |s|
      @boards = @boards.board_search(s)
    end

    @search_params = params[:search_params]

    render '/boards/lists'
  end

  def attention
    @boards = Board.all
      .page(params[:page])
      .order('board_comments_count desc')
      .includes(:user)

    render '/boards/lists'
  end

  def my_posts
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    @boards = Board.where(user_id: current_user.id).page(params[:page]).includes(:user).includes(:board_tags)

    render '/boards/lists'
  end

  def my_commented
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    @boards = Board.joins(:board_comments)
                    .where('board_comments.user_id = ?', current_user.id)
                    .order('board_comments.created_at desc')
                    .page(params[:page])
                    .includes(:user)

    render '/boards/lists'
  end

  def like_lists
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    @boards = Board.joins(:board_likes)
                    .where('board_likes.user_id = ?', current_user.id)
                    .order('board_likes.created_at desc')
                    .page(params[:page])
                    .includes(:user)

    render '/boards/lists'
  end

  def show
    @board_comment = BoardComment.new
    @master_comment = BoardComment.where(board_id: @board.id).order('created_at asc').first
    @board_comments = BoardComment.where(board_id: @board.id).order('created_at desc').page(params[:page]).includes(:user)
    @likes = BoardLike.where('board_id = ?', params[:id])
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def like
    unless @board.like_user(current_user.id)
      @like = BoardLike.create(user_id: current_user.id, board_id: params[:id])
    else
      @like = current_user.board_likes.find_by(board_id: params[:id])
      @like.destroy
    end
      @likes = BoardLike.where(board_id: params[:id])
  end

  def new
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    @board = Board.new
    @board_comment = BoardComment.new
    @board.board_tags.build
  end

  def create
    unless user_signed_in?
      redirect_to new_user_session_path and return
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
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end

    @board_comment = BoardComment.where(board_id: @board.id).order('created_at asc').first
    @board.board_tags.build
  end

  def destroy
    redirect_to root_path and return if user_level_check(2)
    #@board.destroy
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
