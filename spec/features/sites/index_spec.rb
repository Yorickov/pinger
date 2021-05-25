# frozen_string_literal: true

require 'rails_helper'

feature 'Guest can see all sites added for monitoring' do
  given!(:sites) { create_list(:site, 2) }

  background { visit root_path }

  scenario 'Guest try to see sites' do
    # TODO: localize
    click_on 'All sites'

    within 'table' do
      sites.each do |site|
        [site.name, site.url].each { |content| expect(page).to have_content(content) }
      end
    end
  end
end
