# frozen_string_literal: true

class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)

    if @site.save
      redirect_to root_path, notice: 'Site created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end
end
