# frozen_string_literal: true

require 'rails_helper'

feature 'User can ping his site without saving data in database' do
  given(:user) { create(:user) }
  given(:site) { create(:site, user: user) }
  given(:response) { { status: 'success', response_message: 'OK', response_time: 100 } }

  describe 'Authenticated authorized user' do
    background { mock_ping_http_client(site, response) }
    background do
      sign_in(user)
      visit "/sites/#{site.id}"
    end

    scenario 'sees ping success results', js: true do
      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: success')
      end
    end

    scenario 'sees ping failed results', js: true do
      response[:status] = 'failed'

      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: failed')
      end
    end

    scenario 'sees ping errored results', js: true do
      response[:status] = 'errored'

      within '.site-info' do
        click_on t('links.ping')

        expect(page).to have_content('Status: errored')
      end
    end
  end

  describe 'Authenticated not authorized user' do
    background { sign_in(create(:user)) }

    scenario 'do not see site info' do
      expect(page).not_to have_content(site.name)
    end
  end
end
