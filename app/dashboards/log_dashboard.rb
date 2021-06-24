# frozen_string_literal: true

require 'administrate/base_dashboard'

class LogDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    site: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[name]),
    id: Field::Number,
    status: Field::String,
    response_message: Field::Text.with_options(searchable: true),
    response_time: Field::Number,
    created_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    updated_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M')
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    status
    response_message
    created_at
    site
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    status
    response_time
    response_message
    created_at
    updated_at
    site
  ].freeze

  FORM_ATTRIBUTES = %i[
    status
    response_time
    response_message
    site
  ].freeze

  COLLECTION_FILTERS = {}.freeze
end
