# frozen_string_literal: true

class SiteStatusService
  RESPONSE_TIME_LIMIT = 500
  MAPPING = [
    {
      check: ->(response_status) { [Log::STATE_ERRORED, Log::STATE_TIMEOUT_ERROR].any?(response_status) },
      status: Site::STATE_INACTIVE
    },
    {
      check: ->(response_status) { [Log::STATE_FAILED, Log::STATE_CONTENT_MISSING].any?(response_status) },
      status: Site::STATE_DOWN
    },
    {
      check: ->(response_status) { response_status == Log::STATE_SUCCESS },
      status: Site::STATE_UP
    }
  ].freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(response)
    @response = response
  end

  def call
    status = MAPPING.find { |item| item[:check].call(response[:status]) }[:status]
    status == Site::STATE_UP ? precise_up_status : status
  end

  private

  attr_reader :response

  def precise_up_status
    response[:response_time] > RESPONSE_TIME_LIMIT ? Site::STATE_SLOW : Site::STATE_UP
  end
end
