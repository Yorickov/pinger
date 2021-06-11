# frozen_string_literal: true

require 'faraday'

module HttpClient
  class << self
    # TODO: add request options (timeout, etc as site settings)
    def call(url)
      connection = setup_connection(url)
      make_request(connection)
    end

    private

    def setup_connection(url)
      # TODO: take out timeout in options
      Faraday::Connection.new(url, request: { timeout: 5 })
    end

    def make_request(connection)
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
end
