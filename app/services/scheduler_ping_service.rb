# frozen_string_literal: true

module SchedulerPingService
  class << self
    def call
      Site.find_in_batches do |batch|
        Parallel.each(batch, in_threads: 10) do |site|
          ActiveRecord::Base.connection_pool.with_connection { ping(site) }
        end
      end
    end

    private

    def ping(site)
      PingSiteService.call(site) if site.ping_time?
    end
  end
end
