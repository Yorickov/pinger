# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:site) { create(:site, user: user, status: Site::STATE_UP) }
  let(:statuses) { [Site::STATE_INACTIVE, Site::STATE_UP] }

  describe 'status_changed' do
    let(:mail) { NotificationsMailer.status_changed(site, statuses) }

    it 'renders the headers' do
      expect(mail.subject).to eq t('notifications_mailer.status_changed.subject')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['pinger@example.com'])
    end

    it 'renders site name' do
      expect(mail.body.encoded).to match(site.name)
    end

    it 'renders statuses' do
      statuses.each { |status| expect(mail.body.encoded).to match(status.to_s) }
    end
  end
end
