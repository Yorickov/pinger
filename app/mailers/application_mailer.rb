# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Pinger <pinger@example.com>'
  layout 'mailer'
end
