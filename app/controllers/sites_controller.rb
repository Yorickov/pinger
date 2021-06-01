# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :load_site, only: %i[show edit update destroy]

  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
  end

  def show; end

  def create
    @site = Site.new(site_params)

    if @site.save
      redirect_to @site, notice: t('message.site_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @site.update(site_params)
      redirect_to @site, notice: t('message.site_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @site.destroy

    redirect_to sites_path, notice: t('message.site_deleted')
  end

  private

  def site_params
    params.require(:site).permit(:name, :url)
  end

  def load_site
    @site = Site.find(params[:id])
  end
end
