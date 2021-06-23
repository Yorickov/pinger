# frozen_string_literal: true

require 'rails_helper'

feature 'Only admin can visit Admin panel' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, :admin) }
  given(:welcome_admin_text) { 'Back to app' }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit admin_root_path
    end

    scenario 'see admin panel' do
      expect(page).to have_content welcome_admin_text
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit admin_root_path
    end

    scenario 'cannot visit admin panel' do
      expect(page).to have_content t('message.admin_required')
    end
  end

  describe 'Guest' do
    background { visit admin_root_path }

    scenario 'cannot visit admin panel' do
      expect(page).to have_content t('message.admin_required')
    end
  end
end
