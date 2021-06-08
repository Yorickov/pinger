# frozen_string_literal: true

require 'rails_helper'

feature 'User can ping site without saving data in database' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:site) { create(:site, user: user1) }

  describe 'Authenticated authorized user' do
    background { sign_in(user1) }

    scenario 'sees ping success results', js: true do
      visit "/sites/#{site.id}"
      stub_valid_request(site.url, 200)

      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: success')
      end
    end

    scenario 'sees ping failed results', js: true do
      visit "/sites/#{site.id}"
      stub_valid_request(site.url, 500)

      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: failed')
      end
    end

    scenario 'sees ping errored results', js: true do
      visit "/sites/#{site.id}"
      stub_error_request(site.url)

      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: errored')
      end
    end
  end

  describe 'Authenticated not authorized user' do
    background { sign_in(user2) }

    scenario 'do not see site info' do
      expect(page).not_to have_content(site.name)
    end
  end
end
