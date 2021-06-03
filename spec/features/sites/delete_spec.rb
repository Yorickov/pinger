# frozen_string_literal: true

require 'rails_helper'

feature 'Uer can delete his site' do
  given(:user1) { create(:user) }
  given!(:site) { create(:site, user: user1) }
  given(:user2) { create(:user) }

  describe 'Authenticated authorized user' do
    background do
      sign_in(user1)
      visit sites_path
    end

    scenario 'deletes his site' do
      [site.name, site.url].each { |content| expect(page).to have_content(content) }

      within 'table' do
        click_on t('links.delete')
      end

      [site.name, site.url].each { |content| expect(page).not_to have_content(content) }
    end
  end

  describe 'Authenticated not authorized user' do
    background do
      sign_in(user2)
      visit sites_path
    end

    scenario "fails to delete another user's site" do
      within 'table' do
        expect(page).not_to have_content t('links.delete')
      end
    end
  end
end
