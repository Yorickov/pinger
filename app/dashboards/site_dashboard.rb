# frozen_string_literal: true

require 'administrate/base_dashboard'

class SiteDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
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

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    status
    user
    logs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
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

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    interval
    timeout
    enabled
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

  # Overwrite this method to customize how sites are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(site)
    site.name
  end
end
