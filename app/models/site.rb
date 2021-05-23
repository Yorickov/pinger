# frozen_string_literal: true

class Site < ApplicationRecord
  validates :name, presence: true
  validates :name, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { name.present? }
end
