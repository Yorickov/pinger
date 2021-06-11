# frozen_string_literal: true

module ApplicationHelper
  def format_unix_time(time)
    Time.zone.at(time).strftime('%d-%m-%Y %H:%M')
  end

  def format_utc_time(time)
    time.strftime('%d-%m-%Y %H:%M')
  end

  def truncate(text, length = 20)
    text.truncate(length)
  end
end
