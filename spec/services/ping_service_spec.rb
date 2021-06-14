# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  let(:user) { create(:user_with_sites) }
  let(:site) { user.sites.first }

  after { described_class.call(site.full_url) }

  it 'pinging http-service called' do
    expect(HttpClient).to receive(:call).with(site.full_url)
  end
end
