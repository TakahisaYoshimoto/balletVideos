class SiteConfigurationsController < ApplicationController
  before_action :set_site_config, only: [:show, :edit, :update]

  def index
    redirect_to root_path and return if user_level_check(2)
    @site_configurations = SiteConfiguration.all
  end

  def show
    redirect_to root_path and return if user_level_check(2)
  end

  def new
    redirect_to root_path and return if user_level_check(2)
    @site_config = SiteConfiguration.new
  end

  def create
    redirect_to root_path and return if user_level_check(2)
    @site_config = SiteConfiguration.new(site_config_params)

    if @site_config.save
      redirect_to @site_config
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path and return if user_level_check(2)
  end

  def update
    redirect_to root_path and return if user_level_check(2)
    if @site_config.update(site_config_params)
      redirect_to @site_config
    else
      render 'edit'
    end
  end

  private
    def set_site_config
      @site_config = SiteConfiguration.find(params[:id])
    end

    def site_config_params
      params.require(:site_configuration).permit(:item, :summary, :contents)
    end
end
