class TopTagListsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = TopTagList.all.order('hurigana asc')
  end

  def new
    user_level_check(2)
    @tag = TopTagList.new
  end

  def create
    user_level_check(2)
    @tag = TopTagList.new(tag_params)
    if @tag.save      
      redirect_to top_tag_lists_path
    else
      render 'new'
    end
  end

  def edit
    @tag = TopTagList.find(params[:id])
  end

  def update
    user_level_check(2)
    if @tag.update(tag_params)
      redirect_to top_tag_lists_path
    else
      render 'edit'
    end
  end

  def destroy
    user_level_check(2)
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

    def user_level_check(level)
      if current_user.nil?
        redirect_to bits_path and return
      end
      unless current_user.nil?
        if level > current_user.user_level
          redirect_to bits_path and return
        end
      end      
    end
end
