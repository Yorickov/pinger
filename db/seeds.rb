# frozen_string_literal: true

User.create(
  email: Rails.application.credentials.admin[:email],
  password: Rails.application.credentials.admin[:password],
  password_confirmation: Rails.application.credentials.admin[:password],
  role: 'admin'
)
