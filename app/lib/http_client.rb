# frozen_string_literal: true

require 'faraday'

class HttpClient
  DEFAULT_REQUEST_OPTIONS = { timeout: 10 }.freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(url, options = {})
    @options = DEFAULT_REQUEST_OPTIONS.merge(options)
    @connection = setup_connection(url)
  end

  def call
    make_request
  end

  private

  attr_reader :options, :connection

  def setup_connection(url)
    Faraday::Connection.new(url, request: options)
  end

  def make_request
    start = Time.now.utc

    begin
      res = connection.get
      {
        status: res.status >= 400 ? 'failed' : 'success',
        response_message: res.reason_phrase,
        response_time: calc_response_time(start)
      }
    # TODO: add special handling?
    # rescue Faraday::TimeoutError => _e
    #   { status: 'timeout errored' }
    rescue StandardError => e
      { status: 'errored', response_message: e.message }
    end
  end

  def calc_response_time(start_time)
    (Time.now.utc - start_time).in_milliseconds.to_i
  end
end
