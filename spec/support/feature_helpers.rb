# frozen_string_literal: true

module FeatureHelpers
  def fill_in_site_form(name, url, label)
    fill_in 'Name', with: name
    fill_in 'Url', with: url
    click_on label
  end
end
