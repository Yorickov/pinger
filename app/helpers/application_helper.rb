# frozen_string_literal: true

module ApplicationHelper
  def format_unix_time(time)
    Time.zone.at(time).strftime('%d-%m-%Y %H:%M')
  end

  def format_utc_time(time)
    time.strftime('%d-%m-%Y %H:%M').in_time_zone
  end

  def truncate(text, length = 30)
    text.truncate(length)
  end
end
