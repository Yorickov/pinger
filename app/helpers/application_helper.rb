# frozen_string_literal: true

module ApplicationHelper
  TRUNCATE_MODIFIER = 30

  def format_unix_time(time)
    Time.zone.at(time).strftime('%d-%m-%Y %H:%M')
  end

  def format_utc_time(time)
    time.strftime('%d-%m-%Y %H:%M').in_time_zone
  end

  def truncate(text, length = TRUNCATE_MODIFIER)
    text.truncate(length)
  end
end
