# frozen_string_literal: true

module SitesHelper
  def format_time(unix_time)
    Time.zone.at(unix_time).strftime('%d-%m-%Y %H:%M')
  end
end
