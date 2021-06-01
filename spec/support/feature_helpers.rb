# frozen_string_literal: true

module FeatureHelpers
  def fill_in_site_form(name, url, label)
    fill_in t('activerecord.attributes.site.name'), with: name
    fill_in t('activerecord.attributes.site.url'), with: url
    click_on label
  end
end
