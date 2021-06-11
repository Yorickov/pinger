# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  interval       :integer          not null
#  last_pinged_at :integer
#  name           :string           not null
#  protocol       :string           not null
#  status         :string           default("inactive")
#  url            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_sites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# require 'aasm'

class Site < ApplicationRecord
  include AASM

  SECONDS_IN_MINUTE = 60

  belongs_to :user
  has_many :logs, -> { order(created_at: :desc) }, dependent: :destroy

  validates :name, :interval, presence: true
  validates :protocol, presence: true, inclusion: { in: %w[http:// https://] }

  validates :url, presence: true
  validate :validate_url_format

  aasm column: 'status' do
    state :inactive, initial: true
    state :active

    # TODO: still in working
    # event :activate do
    #   transitions from: %i[inactive active], to: :active
    # end

    # event :inactivate do
    #   transitions from: %i[active inactive], to: :inactive
    # end
  end

  def full_url
    [protocol, url].join
  end

  def ping_time?
    minutes_from_last_ping >= interval && enabled?
  end

  private

  def minutes_from_last_ping
    (Time.now.utc.to_i - (last_pinged_at || created_at.to_i)) / SECONDS_IN_MINUTE
  end

  def validate_url_format
    return if url.blank? || full_url =~ URI::DEFAULT_PARSER.make_regexp

    errors.add :url, I18n.t('activerecord.errors.messages.url_format')
  end
end
