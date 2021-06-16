# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  let(:site) { build(:site) }

  after { described_class.call(site.full_url, {}) }

  it 'pinging http-service called' do
    expect(HttpClient).to receive(:call).with(site.full_url, {})
  end
end
