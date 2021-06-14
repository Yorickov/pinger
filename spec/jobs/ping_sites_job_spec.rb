# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingSitesJob, type: :job do
  after { described_class.perform_now }

  it 'calls PingSchedulerService#call' do
    expect(PingSchedulerService).to receive(:call)
  end
end
