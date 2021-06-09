# frozen_string_literal: true

require 'rails_helper'

feature 'User can see info about any of his sites' do
  given(:user1) { create(:user_with_sites, sites_count: 2) }
  given(:site) { user1.sites.second }
  given(:user2) { create(:user) }

  describe 'Authenticated authorized user' do
    background { sign_in(user1) }

    scenario 'can see info about second site' do
      find('table>tbody>tr:last-child').click_on site.name

      within '.site-info' do
        [site.name, site.full_url].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Authenticated not authorized user' do
    background { sign_in(user2) }

    scenario "can not update another user's site" do
      within 'table' do
        expect(page).not_to have_content(site.name)
      end
    end
  end
end
