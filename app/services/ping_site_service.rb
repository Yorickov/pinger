# frozen_string_literal: true

class PingSiteService
  def self.call(*args)
    new(*args).call
  end

  def initialize(site)
    @site = site
  end

  def call
    prepare!

    response = make_ping
    save_result(response)
  end

  private

  attr_reader :site

  def prepare!
    site.update!(enabled: false)
  end

  def make_ping
    Clients::HttpRequest.call(site.full_url)
  end

  def save_result(response)
    ActiveRecord::Base.transaction do
      site.logs.create!(**response)
      site.update!(
        last_pinged_at: normalize_current_time,
        status: change_status(response),
        enabled: true
      )
    end
  end

  def normalize_current_time
    Time.now.utc.to_i
  end

  # TODO: very preliminary version
  def change_status(response)
    response[:status] == 'success' ? 'active' : 'inactive'
  end
end
