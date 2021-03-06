# frozen_string_literal: true

require 'faraday'

class HttpClient
  DEFAULT_OPTIONS = { timeout: 10, checking_string: '' }.freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(url, options = {})
    @options = DEFAULT_OPTIONS.merge(options)
    @connection = setup_connection(url)
  end

  def call
    make_request
  end

  private

  attr_reader :options, :connection

  def setup_connection(url)
    Faraday.new(url, request: options.slice(:timeout)) do |f|
      f.response :logger, nil, { headers: false }
    end
  end

  def make_request
    start_time = Time.now.utc

    begin
      res = connection.get
      end_time = Time.now.utc

      return build_response(Log::STATE_CONTENT_MISSING, "<#{options[:checking_string]}> lacks") if no_content?(res.body)

      if res.status >= 400
        build_response(Log::STATE_FAILED, res.reason_phrase)
      else
        build_response(Log::STATE_SUCCESS, res.reason_phrase, calc_response_time(start_time, end_time))
      end
    rescue Faraday::TimeoutError => e
      build_response(Log::STATE_TIMEOUT_ERROR, e.message)
    rescue StandardError => e
      build_response(Log::STATE_ERRORED, e.message)
    end
  end

  def calc_response_time(start_time, end_time)
    (end_time - start_time).in_milliseconds.to_i
  end

  def no_content?(content)
    options[:checking_string].present? && !content.include?(options[:checking_string])
  end

  def build_response(status, response_message, response_time = nil)
    { status: status, response_message: response_message, response_time: response_time }.compact
  end
end
