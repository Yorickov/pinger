# frozen_string_literal: true

class NotificationsMailer < ApplicationMailer
  def status_changed(site, statuses)
    @site = site
    @old_status, @new_status = statuses

    mail to: @site.user.email
  end
end
