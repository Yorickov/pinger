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
      fill_in_site_form(name, valid_url, I18n.t('helpers.submit.create'))

      within '.site-info' do
        [name, valid_url].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Guest fails to add site' do
    scenario 'when name and url are not filled in' do
      click_on I18n.t('helpers.submit.create')

      [I18n.t('attributes.name'), I18n.t('attributes.url')].each do |attr|
        expect(page).to have_content("#{attr} #{I18n.t('activerecord.errors.models.site.blank')}")
      end

    end

    scenario 'when url is not valid' do
      fill_in_site_form(name, invalid_url, I18n.t('helpers.submit.create'))

      expect(page).to have_content("#{I18n.t('attributes.url')} #{I18n.t('activerecord.errors.models.site.attributes.url.invalid')}")
    end
  end
end
