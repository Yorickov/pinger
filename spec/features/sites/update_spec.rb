# frozen_string_literal: true

require 'rails_helper'

# TODO: localize all spec
feature 'Guest can update site for monitoring' do
  given!(:site) { create(:site) }

  given(:new_name) { attributes_for(:site)[:name] }
  given(:new_valid_url) { attributes_for(:site)[:url] }
  given(:new_invalid_url) { attributes_for(:site, :invalid)[:url] }

  background do
    visit sites_path
    find('table>tbody>tr').click_on('Edit')
  end

  describe 'Guest try to update site' do
    scenario 'updated site info appears on site page' do
      fill_in_site_form(new_name, new_valid_url, 'Update Site')

      [new_name, new_valid_url].each { |content| expect(page).to have_content(content) }
    end
  end

  describe 'Guest fails to update site' do
    scenario 'when name and url are not filled in' do
      fill_in_site_form('', '', 'Update Site')

      ["Name can't be blank", "Url can't be blank"].each { |content| expect(page).to have_content(content) }
    end

    scenario 'when url is not valid' do
      fill_in_site_form(new_name, new_invalid_url, 'Update Site')

      expect(page).to have_content 'Url is invalid'
    end
  end
end
