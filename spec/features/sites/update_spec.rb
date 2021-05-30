# frozen_string_literal: true

require 'rails_helper'

feature 'Guest can update site for monitoring' do
  given!(:site) { create(:site) }

  given(:new_name) { attributes_for(:site)[:name] }
  given(:new_valid_url) { attributes_for(:site)[:url] }
  given(:new_invalid_url) { attributes_for(:site, :invalid)[:url] }

  background do
    visit sites_path
    find('table>tbody>tr').click_on t('links.edit')
  end

  describe 'Guest try to update site' do
    scenario 'updated site info appears on site page' do
      fill_in_site_form(new_name, new_valid_url, t('helpers.submit.update'))

      [new_name, new_valid_url].each { |content| expect(page).to have_content(content) }
    end
  end

  describe 'Guest fails to update site' do
    scenario 'when name and url are not filled in' do
      fill_in_site_form('', '', t('helpers.submit.update'))

      [t('activerecord.attributes.site.name'), t('activerecord.attributes.site.url')].each do |attr|
        expect(page).to have_content([attr, t('activerecord.errors.messages.blank')].join(' '))
      end
    end

    scenario 'when url is not valid' do
      fill_in_site_form(new_name, new_invalid_url, t('helpers.submit.update'))

      expect(page).to have_content(
        [t('activerecord.attributes.site.url'), t('activerecord.errors.messages.invalid')].join(' ')
      )
    end
  end
end
