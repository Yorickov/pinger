# frozen_string_literal: true

require 'administrate/base_dashboard'

class SiteDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[email]),
    logs: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    url: Field::String,
    created_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    updated_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    enabled: Field::Boolean,
    status: Field::String,
    last_pinged_at: Field::Number,
    protocol: Field::String,
    interval: Field::Number,
    timeout: Field::Number,
    checking_string: Field::String
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    status
    user
    logs
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    protocol
    url
    interval
    timeout
    checking_string
    enabled
    status
    last_pinged_at
    created_at
    updated_at
    user
    logs
  ].freeze

  FORM_ATTRIBUTES = %i[
    interval
    timeout
    enabled
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(site)
    site.name
  end
end
