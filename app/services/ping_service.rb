# frozen_string_literal: true

# TODO: remove without additional functions ?
module PingService
  module_function

  def call(url, options = {})
    HttpClient.call(url, options)
  end
end
