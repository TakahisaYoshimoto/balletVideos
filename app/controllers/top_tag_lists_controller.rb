class TopTagListsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to root_path and return if user_level_check(2)
    # @tags = TopTagList.all.order('hurigana asc')
  end

  def new
    redirect_to root_path and return if user_level_check(2)
    @tag = TopTagList.new
  end

  def create
    redirect_to root_path and return if user_level_check(2)
    @tag = TopTagList.new(tag_params)
    if @tag.save      
      redirect_to top_tag_lists_path
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path and return if user_level_check(2)
    @tag = TopTagList.find(params[:id])
  end

  def update
    redirect_to root_path and return if user_level_check(2)
    if @tag.update(tag_params)
      redirect_to top_tag_lists_path
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path and return if user_level_check(2)
    @tag.destroy
    redirect_to top_tag_lists_path
  end

  private
    def set_tag
      @tag = TopTagList.find(params[:id])
    end

    def tag_params
      params.require(:top_tag_list).permit(:genre, :tag_name, :hurigana)
    end
end
