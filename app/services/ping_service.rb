# frozen_string_literal: true

require 'faraday'

class PingService
  def self.call(*args)
    new(*args).call
  end

  def initialize(site)
    @site = site
    @client = Faraday
  end

  def call
    result = http_request

    site.update!(last_pinged_at: Time.now.utc.to_i, status: 'active')

    result
  end

  private

  attr_reader :site, :client

  def http_request
    start = Time.now.utc
    res = client.get(site.url)
    {
      status: 'succesfull',
      code: res.status,
      response_time: calc_response_time(start)
    }
  rescue StandardError => _e
    { status: 'errored' }
  end

  def calc_response_time(start_time)
    (Time.now.utc - start_time).in_milliseconds
  end
end
