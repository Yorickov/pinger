# frozen_string_literal: true

class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @query = site.logs.ransack(params[:q])
    @logs = @query.result(distinct: true).page(params[:page])
  end

  private

  def site
    @site ||= Site.find(params[:site_id])
  end
end
