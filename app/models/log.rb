# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id               :bigint           not null, primary key
#  response_message :text
#  response_time    :integer
#  status           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  site_id          :bigint           not null
#
# Indexes
#
#  index_logs_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
class Log < ApplicationRecord
  include AASM

  belongs_to :site

  validates :status, presence: true

  aasm column: 'status' do
    state :success
    state :failed
    state :errored
    state :timeout_error
  end

  paginates_per 10
end
