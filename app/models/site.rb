# frozen_string_literal: true

class Site < ApplicationRecord
  validates :name, presence: true

  validates :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { url.present? }
end
