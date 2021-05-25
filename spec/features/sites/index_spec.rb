# frozen_string_literal: true

require 'rails_helper'

feature 'Guest can see all sites added for monitoring' do
  given!(:sites) { create_list(:site, 2) }

  scenario 'Guest try to see sites' do
    visit root_path
    # TODO: localize
    click_on 'All sites'

    sites.each do |site|
      [site.name, site.url].each { |content| expect(page).to have_content(content) }
    end
  end
end
