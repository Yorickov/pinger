# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :load_site, only: %i[show edit update]

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
      # TODO: localize
      redirect_to @site, notice: 'Site created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @site.update(site_params)
      # TODO: localize
      redirect_to @site, notice: 'Site updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def site_params
    params.require(:site).permit(:name, :url)
  end

  def load_site
    @site = Site.find(params[:id])
  end
end
