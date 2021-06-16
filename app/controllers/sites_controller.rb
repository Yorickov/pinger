# frozen_string_literal: true

class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_site, only: %i[show edit update destroy ping_current]

  def index
    @q = current_user.sites.includes(:logs).ransack(params[:q])
    @sites = @q.result(distinct: true)
  end

  def new
    @site = current_user.sites.new
  end

  def show
    authorize @site

    @q = @site.logs.ransack(params[:q])
    @logs = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
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

    render_ping_info_in_json(@site.full_url, @site.attributes.slice('timeout', 'checking_string').compact)
  end

  def ping_new
    logger.info "Receiving url: #{params[:url]} timeout: #{params[:timeout]} checking: #{params[:checking_string]}"
    render_ping_info_in_json(params[:url], params.permit(:timeout, :checking_string).compact_blank.as_json)
  end

  private

  def site_params
    params.require(:site).permit(:name, :url, :interval, :protocol, :timeout, :checking_string)
  end

  def load_site
    @site = Site.find(params[:id])
  end

  def render_ping_info_in_json(url, options)
    options['timeout'] = options['timeout'].to_i if options.key?('timeout')
    ping_info = PingService.call(url, options.symbolize_keys)
    render json: ping_info
  end
end
