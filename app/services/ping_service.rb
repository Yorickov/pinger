# frozen_string_literal: true

module PingService
  module_function

  def call(site)
    return if site.enabled == false

    # TODO: pass url not site
    Client::HttpRequest.call(site.full_url)
  end
end
