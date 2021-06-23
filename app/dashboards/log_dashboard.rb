# frozen_string_literal: true

require 'administrate/base_dashboard'

class LogDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    site: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[name]),
    id: Field::Number,
    status: Field::String,
    response_message: Field::Text.with_options(searchable: true),
    response_time: Field::Number,
    created_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M'),
    updated_at: Field::DateTime.with_options(format: '%d-%m-%Y %H:%M')
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    status
    response_message
    created_at
    site
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    status
    response_time
    response_message
    created_at
    updated_at
    site
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    status
    response_time
    response_message
    site
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how logs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(log)
  #   "Log ##{log.id}"
  # end
end
