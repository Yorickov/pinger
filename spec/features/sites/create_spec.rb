# frozen_string_literal: true

require 'rails_helper'

# TODO: localize all spec
feature 'Guest can add site for monitoring' do
  given(:name) { attributes_for(:site)[:name] }
  given(:valid_url) { attributes_for(:site)[:url] }
  given(:invalid_url) { attributes_for(:site, :invalid)[:url] }

  background do
    visit root_path
    click_on t('label.add_site')
  end

  describe 'Guest try to add site' do
    scenario 'created site info appears on site page' do
      fill_in_site_form(name, valid_url, t('helpers.submit.create'))

      within '.site-info' do
        [name, valid_url].each { |content| expect(page).to have_content(content) }
      end
    end
  end

  describe 'Guest fails to add site' do
    scenario 'when name and url are not filled in' do
      click_on t('helpers.submit.create')

      [t('activerecord.attributes.site.name'), t('activerecord.attributes.site.url')].each do |attr|
        expect(page).to have_content([attr, t('activerecord.errors.messages.blank')].join(' '))
      end
    end

    scenario 'when url is not valid' do
      fill_in_site_form(name, invalid_url, t('helpers.submit.create'))

      expect(page).to have_content(
        [t('activerecord.attributes.site.url'), t('activerecord.errors.messages.invalid')].join(' ')
      )
    end
  end
end
