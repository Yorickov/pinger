# frozen_string_literal: true

module PingService
  module_function

  def call(site)
    return if site.enabled == false

    Client::HttpRequest.call(site.url)
  end
end
