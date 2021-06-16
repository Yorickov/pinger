# frozen_string_literal: true

require 'faraday'

class HttpClient
  DEFAULT_OPTIONS = { timeout: 10 }.freeze

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

      if content_check?(res.body)
        status = res.status >= 400 ? 'failed' : 'success'
        build_response(status, res.reason_phrase, calc_response_time(start_time, end_time))
      else
        build_response('content_missing', "<#{options[:checking_string]}> missing")
      end
    rescue Faraday::TimeoutError => e
      build_response('timeout_error', e.message)
    rescue StandardError => e
      build_response('errored', e.message)
    end
  end

  def calc_response_time(start_time, end_time)
    (end_time - start_time).in_milliseconds.to_i
  end

  def content_check?(content)
    return true unless options.key?(:checking_string)

    content.include?(options[:checking_string])
  end

  def build_response(status, response_message, response_time = nil)
    response = { status: status, response_message: response_message }
    response[:response_time] = response_time if response_time
    response
  end
end
