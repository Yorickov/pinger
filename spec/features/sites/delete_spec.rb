# frozen_string_literal: true

require 'rails_helper'

# TODO: localize all spec
feature 'Guest can delete site' do
  given!(:site) { create(:site) }

  background { visit sites_path }

  scenario 'deleted site absents on sites page' do
    [site.name, site.url].each { |content| expect(page).to have_content(content) }

    find('table>tbody>tr').click_on('Delete')

    [site.name, site.url].each { |content| expect(page).not_to have_content(content) }
  end
end
