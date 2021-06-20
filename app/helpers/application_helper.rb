# frozen_string_literal: true

module ApplicationHelper
  TRUNCATE_MODIFIER = 100
  STATUS_MAPPING = { 'up' => 'success', 'slow' => 'warning', 'down' => 'danger', 'inactive' => 'muted' }.freeze

  def format_unix_time(time)
    Time.zone.at(time).strftime('%d-%m-%Y %H:%M')
  end

  def format_utc_time(time)
    time.in_time_zone.strftime('%d-%m-%Y %H:%M')
  end

  def truncate(text, length = TRUNCATE_MODIFIER)
    text.truncate(length)
  end

  def format_data(value)
    text, klass = if value.zero?
                    [I18n.t('helpers.no_data'), 'text-muted']
                  else
                    ["#{value} #{I18n.t('helpers.ms')}", 'fw-bold fst-italic']
                  end
    tag.span(text, class: klass)
  end

  def ping_ability(site)
    site.enabled? ? I18n.t('helpers.disable') : I18n.t('helpers.enable')
  end

  def format_status(site)
    text = status_name(site).capitalize
    color = "text-#{STATUS_MAPPING[site.status]}"
    tag.h1(text, class: color)
  end

  def status_name(site)
    site.enabled? ? site.status : 'disabled'
  end
end
