# frozen_string_literal: true

# TODO: remove without additional functions ?
module PingService
  module_function

  def call(url)
    HttpClient.call(url)
  end
end
