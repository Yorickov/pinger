# frozen_string_literal: true

# TODO: remove without additional functions
module PingService
  module_function

  def call(url)
    Clients::HttpRequest.call(url)
  end
end
