# frozen_string_literal: true

require 'rails_helper'

feature 'User can see info about any of his sites' do
  given(:user) { create(:user_with_sites, sites_count: 2) }
  given(:site) { user.sites.second }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit sites_path
    end

    scenario 'can see info about second site' do
      find('table>tbody>tr:last-child').click_on site.name

      within '.site-info' do
        [site.name, site.url].each { |content| expect(page).to have_content(content) }
      end
    end
  end
end
