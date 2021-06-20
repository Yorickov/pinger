# frozen_string_literal: true

require 'rails_helper'

feature 'User can see all sites added by him for monitoring' do
  given(:user1) { create(:user_with_sites) }
  given(:site) { user1.sites.first }
  given!(:log) { create(:log, site: site, status: 'success') }
  given!(:user2) { create(:user_with_sites) }

  describe 'Authenticated user' do
    background do
      sign_in(user1)
      click_on site.name
      click_on t('links.all_logs')
    end

    scenario 'sees ping history of site added by him' do
      within 'table' do
        [log.status, log.response_time, log.response_message].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Guest' do
    background { visit root_path }

    scenario "doesn't see site list, so he can't" \
      'manipulate (show, update, destroy, ping) with any site' do
      expect(page).not_to have_content t('label.all_sites')
    end
  end
end
