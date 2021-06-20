# frozen_string_literal: true

require 'rails_helper'

feature 'User can manage site ping ability' do
  given(:user1) { create(:user) }
  given!(:site) { create(:site, user: user1) }
  given(:user2) { create(:user) }

  describe 'Authenticated authorized user' do
    background do
      sign_in(user1)
      visit "/sites/#{site.id}"
    end

    scenario 'change site ping ability' do
      click_on t('helpers.disable')

      expect(page).to have_content t('helpers.enable')

      click_on t('helpers.enable')

      expect(page).to have_content t('helpers.disable')
    end
  end

  describe 'Authenticated not authorized user' do
    background { sign_in(user2) }

    scenario "fails to stop to ping another user's site" do
      within 'table' do
        expect(page).not_to have_content site.name
      end
    end
  end
end
