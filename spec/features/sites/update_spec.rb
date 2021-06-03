# frozen_string_literal: true

require 'rails_helper'

feature 'User can update site added by him for monitoring' do
  given(:user1) { create(:user_with_sites) }
  given(:site) { user1.sites.first }
  given(:user2) { create(:user) }

  given(:new_name) { attributes_for(:site)[:name] }
  given(:new_valid_url) { attributes_for(:site)[:url] }
  given(:new_invalid_url) { attributes_for(:site, :invalid)[:url] }

  describe 'Authenticated authorized user' do
    background do
      sign_in(user1)
      within 'table' do
        click_on t('links.edit')
      end
    end

    scenario 'updates his site' do
      fill_in t('activerecord.attributes.site.name'), with: new_name
      fill_in t('activerecord.attributes.site.url'), with: new_valid_url
      click_on t('helpers.submit.update')

      [new_name, new_valid_url].each { |content| expect(page).to have_content(content) }
    end

    describe 'fails to update' do
      scenario 'whithout name and url' do
        fill_in t('activerecord.attributes.site.name'), with: ''
        fill_in t('activerecord.attributes.site.url'), with: ''
        click_on t('helpers.submit.update')

        [t('activerecord.attributes.site.name'), t('activerecord.attributes.site.url')].each do |attr|
          expect(page).to have_content([attr, t('activerecord.errors.messages.blank')].join(' '))
        end
      end

      scenario 'when url is not valid' do
        fill_in t('activerecord.attributes.site.name'), with: new_name
        fill_in t('activerecord.attributes.site.url'), with: new_invalid_url
        click_on t('helpers.submit.update')

        expect(page).to have_content(
          [t('activerecord.attributes.site.url'), t('activerecord.errors.messages.invalid')].join(' ')
        )
      end
    end
  end

  describe 'Authenticated not authorized user' do
    background do
      sign_in(user2)
    end

    scenario "can not update another user's site" do
      within 'table' do
        expect(page).not_to have_content t('links.edit')
      end
    end
  end
end
