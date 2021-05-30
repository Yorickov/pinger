# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Site < ApplicationRecord
  validates :name, presence: true

  validates :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { url.present? }
end
