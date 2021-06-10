# frozen_string_literal: true

require 'faraday'

module Clients
  class HttpRequest
    def self.call(*args)
      new(*args).call
    end

    # TODO: add request options (timeout, etc as site settings)
    def initialize(url)
      @connection = setup_connection(url)
    end

    def call
      make_request
    end

    private

    attr_reader :connection

    def setup_connection(url)
      # TODO: take out timeout in options
      Faraday::Connection.new(url, request: { timeout: 5 })
    end

    def make_request
      start = Time.now.utc
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

    def calc_response_time(start_time)
      (Time.now.utc - start_time).in_milliseconds.to_i
    end
  end
end
