# frozen_string_literal: true

module ApplicationHelper
  TRUNCATE_MODIFIER = 30

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
    klass = site.enabled? ? 'text-success' : 'text-danger'
    tag.span(site.status, class: klass)
  end
end
