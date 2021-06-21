# frozen_string_literal: true

class NotificationsMailer < ApplicationMailer
  def status_changed(site)
    @site = site
    @log = site.logs.first

    mail to: @site.user.email
  end
end
