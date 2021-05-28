# frozen_string_literal: true

module FeatureHelpers
  def fill_in_site_form(name, url, label)
    fill_in I18n.t('attributes.name'), with: name
    fill_in I18n.t('attributes.url'), with: url
    click_on label
  end
end
