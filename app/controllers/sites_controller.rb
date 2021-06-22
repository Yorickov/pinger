# frozen_string_literal: true

class SitesController < ApplicationController
  LAST_LOGS_LIMIT = 5

  before_action :authenticate_user!
  before_action :load_site, only: %i[show edit update destroy ping_current ping_change]

  def index
    @query = current_user.sites.includes(:logs).ransack(params[:q])
    @sites = @query.result(distinct: true)
  end

  def new
    @site = current_user.sites.new
  end

  def show
    authorize @site

    logs = @site.logs
    @last_logs = logs.first(LAST_LOGS_LIMIT)

    query_params = params[:q] || default_query_params
    @query = logs.ransack(query_params)
    chart_logs = @query.result(distinct: true)

    options = params.key?(:filter) ? { filter: params[:filter] } : {}
    @data, @response_values = ChartService.call(chart_logs, options)
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

    render_ping_info_in_json(@site.full_url, ping_attrubutes)
  end

  def ping_new
    logger.info "Receiving url: #{params[:url]} timeout: #{params[:timeout]} checking: #{params[:checking_string]}"
    render_ping_info_in_json(params[:url], ping_params)
  end

  def ping_change
    authorize @site

    @site.update!(enabled: !@site.enabled)

    redirect_to @site
  end

  private

  def site_params
    params.require(:site).permit(:name, :url, :interval, :protocol, :timeout, :checking_string)
  end

  def ping_params
    params.permit(:timeout, :checking_string).compact_blank.as_json
  end

  def ping_attrubutes
    @site.attributes.slice('timeout', 'checking_string')
  end

  def load_site
    @site = Site.find(params[:id])
  end

  def render_ping_info_in_json(url, options)
    options['timeout'] = options['timeout'].to_i if options.key?('timeout')
    ping_info = PingService.call(url, options.symbolize_keys)
    render json: ping_info
  end

  def default_query_params
    { created_at_gteq: Time.current - 1.hour }
  end
end
