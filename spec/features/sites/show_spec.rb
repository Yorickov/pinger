# frozen_string_literal: true

require 'rails_helper'

feature 'Guest can see info about selected site' do
  given!(:sites) { create_list(:site, 2) }

  background { visit sites_path }

  scenario 'Guest try show info about second site in list' do
    # TODO: localize
    find('table>tbody>tr:last-child').click_on('Show')

    within '.site-info' do
      [sites.second.name, sites.second.url].each { |content| expect(page).to have_content(content) }
    end
  end
end
