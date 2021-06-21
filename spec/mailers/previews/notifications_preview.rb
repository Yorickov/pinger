# frozen_string_literal: true

class NotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifications/status_changed
  def status_changed
    site = Site.new(user: User.first, name: 'good')
    statuses = %w[old new]
    NotificationsMailer.status_changed(site, statuses)
  end
end
