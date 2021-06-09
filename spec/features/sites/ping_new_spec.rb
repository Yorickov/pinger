# frozen_string_literal: true

require 'rails_helper'

feature 'User can ping any url' do
  given(:user) { create(:user) }
  given(:site) { build(:site) }
  given(:response) { { status: 'success', response_message: 'OK', response_time: 100 } }

  describe 'Authenticated user' do
    background { mock_ping_http_client(site, response) }
    background do
      sign_in(user)
      click_on t('label.add_site')
    end

    scenario 'sees ping success results', js: true do
      fill_in t('activerecord.attributes.site.url'), with: site.url
      click_on t('links.ping')

      expect(page).to have_content('Status: success')
    end

    scenario 'sees ping failed results', js: true do
      response[:status] = 'failed'

      fill_in t('activerecord.attributes.site.url'), with: site.url
      click_on t('links.ping')

      expect(page).to have_content('Status: failed')
    end

    scenario 'sees ping errored results', js: true do
      response[:status] = 'errored'

      fill_in t('activerecord.attributes.site.url'), with: site.url
      click_on t('links.ping')

      expect(page).to have_content('Status: errored')
    end
  end

  describe 'Guest' do
    scenario 'do not see site info' do
      visit root_path

      expect(page).not_to have_content t('label.add_site')
    end
  end
end
