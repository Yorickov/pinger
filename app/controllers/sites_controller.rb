# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_site, only: %i[show edit update destroy ping_current]

  def index
    @sites = current_user.sites
  end

  def new
    @site = current_user.sites.new
  end

  def show
    authorize @site

    @logs = @site.logs.order(created_at: :desc).page(params[:page])
  end

  def create
    @site = current_user.sites.new(site_params)

    if @site.save
      redirect_to @site, notice: t('message.site_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @site
  end

  def update
    authorize @site

    if @site.update(site_params)
      redirect_to @site, notice: t('message.site_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @site

    @site.destroy

    redirect_to sites_path, notice: t('message.site_deleted')
  end

  def ping_current
    authorize @site

    render_ping_info_in_json(@site.full_url)
  end

  def ping_new
    logger.info "Receiving url: #{params[:url]}"
    render_ping_info_in_json(params[:url])
  end

  private

  def site_params
    params.require(:site).permit(:name, :url, :interval, :protocol)
  end

  def load_site
    @site = Site.find(params[:id])
  end

  def render_ping_info_in_json(url)
    ping_info = PingService.call(url)
    render json: ping_info
  end
end
