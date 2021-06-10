# frozen_string_literal: true

class PingSitesJob < ApplicationJob
  queue_as :default

  def perform
    SchedulerPingService.call
  end
end
