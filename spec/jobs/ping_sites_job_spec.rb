# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingSitesJob, type: :job do
  it 'calls SchedulerPingService#call' do
    expect(SchedulerPingService).to receive(:call)

    PingSitesJob.perform_now
  end
end
