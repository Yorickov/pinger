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
      fill_in_site_form(new_name, new_valid_url, I18n.t('helpers.submit.update'))

      [new_name, new_valid_url].each { |content| expect(page).to have_content(content) }
    end
  end

  describe 'Guest fails to update site' do
    scenario 'when name and url are not filled in' do
      fill_in_site_form('', '', I18n.t('helpers.submit.update'))

      [I18n.t('attributes.name'), I18n.t('attributes.url')].each do |attr|
        expect(page).to have_content("#{attr} #{I18n.t('activerecord.errors.models.site.blank')}")
      end
    end

    scenario 'when url is not valid' do
      fill_in_site_form(new_name, new_invalid_url, I18n.t('helpers.submit.update'))

      expect(page).to have_content "#{I18n.t('attributes.url')} #{I18n.t('activerecord.errors.models.site.attributes.url.invalid')}"
    end
  end
end
