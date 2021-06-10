# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  let(:site) { create(:site, user: create(:user)) }

  it 'pinging http-service called' do
    expect(Clients::HttpRequest)
      .to receive(:call).with(site.full_url)

    described_class.call(site.full_url)
  end
end
