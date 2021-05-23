# frozen_string_literal: true

require 'rails_helper'

feature 'Guest can add site for monitoring' do
  given(:valid_name) { attributes_for(:site)[:name] }
  given(:invalid_name) { attributes_for(:site, :invalid)[:name] }

  background do
    visit root_path
    click_on 'Add site'
  end

  describe 'Guest adds site' do
    scenario 'successfully' do
      fill_in 'Site name', with: valid_name
      click_on 'Create'

      expect(page).to have_content 'Site created'
    end
  end

  describe 'Guest fails to add site' do
    scenario 'if site name is not filled in' do
      click_on 'Create'

      expect(page).to have_content "Name can't be blank"
    end

    scenario 'if site name is not valid' do
      fill_in 'Site name', with: invalid_name
      click_on 'Create'

      expect(page).to have_content 'Name is invalid'
    end
  end
end
