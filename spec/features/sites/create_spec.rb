# frozen_string_literal: true

require 'rails_helper'

# TODO: localize all spec
feature 'Guest can add site for monitoring' do
  given(:name) { attributes_for(:site)[:name] }
  given(:valid_url) { attributes_for(:site)[:url] }
  given(:invalid_url) { attributes_for(:site, :invalid)[:url] }

  background do
    visit root_path
    click_on I18n.t('label.add_site')
  end

  describe 'Guest try to add site' do
    scenario 'created site info appears on site page' do
      fill_in_site_form(name, valid_url, I18n.t('label.add'))

      within '.site-info' do
        [name, valid_url].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Guest fails to add site' do
    scenario 'when name and url are not filled in' do
      click_on I18n.t('label.add')

      ['name.blank', 'url.blank'].each do |message|
        expect(page).to have_content(I18n.t("activerecord.errors.models.site.attributes.#{message}"))
      end
    end

    scenario 'when url is not valid' do
      fill_in_site_form(name, invalid_url, I18n.t('label.add'))

      expect(page).to have_content I18n.t('activerecord.errors.models.site.attributes.url.invalid')
    end
  end
end
