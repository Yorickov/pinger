# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his site' do
  given(:user1) { create(:user) }
  given!(:site) { create(:site, user: user1) }
  given(:user2) { create(:user) }

  describe 'Authenticated authorized user' do
    background do
      sign_in(user1)
      visit "/sites/#{site.id}"
    end

    scenario 'deletes his site' do
      within '.card' do
        click_on t('links.delete')
      end

      [site.name, site.full_url].each { |content| expect(page).not_to have_content(content) }
    end
  end

  describe 'Authenticated not authorized user' do
    background do
      sign_in(user2)
    end

    scenario "fails to delete another user's site" do
      within 'table' do
        expect(page).not_to have_content site.name
      end
    end
  end
end
