# frozen_string_literal: true

class NotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifications/status_changed
  def status_changed
    site = FactoryBot.create(:site, name: 'good site', user: User.first)
    site.logs.create!(response_message: 'Not Found')

    NotificationsMailer.status_changed(site)
  end
end
