# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_site, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[update destroy]

  def index
    @sites = current_user.sites
  end

  def new
    @site = current_user.sites.new
  end

  def show; end

  def create
    @site = current_user.sites.new(site_params)

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

  def authorize_user
    return if current_user.own_site?(@site)

    redirect_to root_path, status: :forbidden, notice: t('message.no_authorized')
  end
end
