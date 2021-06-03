# frozen_string_literal: true

require 'rails_helper'

feature 'User can see all sites added by him for monitoring' do
  given!(:user1) { create(:user_with_sites) }
  given!(:user2) { create(:user_with_sites) }

  describe 'Authenticated user' do
    background do
      sign_in(user1)
      click_on t('label.all_sites')
    end

    scenario 'sees his sites but not others' do
      within 'table' do
        [user1.sites.first.name, user1.sites.first.url].each { |content| expect(page).to have_content(content) }
        expect(page).not_to have_content(user2.sites.first.name)
      end
    end
  end

  describe 'Guest' do
    background { visit root_path }

    scenario "doesn't see site list, so he can't" \
      'manipulate (show, update, destroy) with any site' do
      expect(page).not_to have_content t('label.all_sites')
    end
  end
end
