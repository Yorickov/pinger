# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:site) { create(:site, user: user, status: Site::STATE_UP) }
  let!(:log) { create(:log, site: site, response_message: 'OK') }

  describe 'status_changed' do
    let(:mail) { NotificationsMailer.status_changed(site) }

    it 'renders the headers' do
      expect(mail.subject).to eq t('notifications_mailer.status_changed.subject')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['pinger@example.com'])
    end

    it 'renders site name and status' do
      [site.name, site.status].each { |attr| expect(mail.body.encoded).to match(attr) }
    end

    it 'renders last log response_message' do
      expect(mail.body.encoded).to match(log.response_message)
    end
  end
end
