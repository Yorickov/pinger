# frozen_string_literal: true

class PersistPingService
  def self.call(*args)
    new(*args).call
  end

  def initialize(site)
    @site = site
  end

  def call
    return if site.enabled == false

    prepare!

    response = make_response
    ActiveRecord::Base.transaction do
      site.logs.create!(**response)
      site.update!(
        last_pinged_at: Time.now.utc.to_i,
        status: 'active',
        enabled: true
      )
    end
  end

  private

  attr_reader :site

  def prepare!
    site.update!(enabled: false)
  end

  def make_response
    Client::HttpRequest.call(site.full_url)
  end
end
