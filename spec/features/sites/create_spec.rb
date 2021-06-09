# frozen_string_literal: true

require 'rails_helper'

feature 'User can add site for monitoring' do
  given(:user) { create(:user) }
  given(:name) { attributes_for(:site)[:name] }
  given(:interval) { attributes_for(:site)[:interval] }
  given(:valid_url) { attributes_for(:site)[:url] }
  given(:invalid_url) { attributes_for(:site, :invalid)[:url] }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      click_on t('label.add_site')
    end

    scenario 'adds site successfully' do
      fill_in t('activerecord.attributes.site.name'), with: name
      fill_in t('activerecord.attributes.site.url'), with: valid_url
      fill_in t('activerecord.attributes.site.interval'), with: interval
      click_on t('helpers.submit.create')

      within '.site-info' do
        [name, valid_url].each { |content| expect(page).to have_content(content) }
      end
    end

    describe 'failes to add site' do
      scenario 'without name' do
        fill_in t('activerecord.attributes.site.url'), with: valid_url
        click_on t('helpers.submit.create')

        expect(page).to have_content([
          t('activerecord.attributes.site.name'),
          t('activerecord.errors.messages.blank')
        ].join(' '))
      end
    end
  end

  describe 'Guest' do
    scenario 'fails to add site' do
      visit root_path

      expect(page).not_to have_content t('label.add_site')
    end
  end
end
