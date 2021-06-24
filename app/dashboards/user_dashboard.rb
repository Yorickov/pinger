# frozen_string_literal: true

require 'administrate/base_dashboard'

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    sites: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    created_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    updated_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    password: PasswordField,
    password_confirmation: PasswordField
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    email
    created_at
    sites
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    email
    created_at
    updated_at
    sites
  ].freeze

  FORM_ATTRIBUTES = %i[
    email
    password
    password_confirmation
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(user)
    user.email
  end
end
