# frozen_string_literal: true

require 'rails_helper'

# TODO: localize all spec
feature 'Guest can add site for monitoring' do
  given(:name) { attributes_for(:site)[:name] }
  given(:valid_url) { attributes_for(:site)[:url] }
  given(:invalid_url) { attributes_for(:site, :invalid)[:url] }

  background do
    visit root_path
    click_on 'Add site'
  end

  describe 'Guest try to add site' do
    scenario 'created site info appears on site page' do
      fill_in 'Name', with: name
      fill_in 'Url', with: valid_url
      click_on 'Create'

      within '.site-info' do
        [name, valid_url].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Guest fails to add site' do
    scenario 'when name and url are not filled in' do
      click_on 'Create'

      ["Name can't be blank", "Url can't be blank"].each { |content| expect(page).to have_content(content) }
    end

    scenario 'when url is not valid' do
      fill_in 'Name', with: name
      fill_in 'Url', with: invalid_url
      click_on 'Create'

      expect(page).to have_content 'Url is invalid'
    end
  end
end
