# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  let(:site) { create(:site, user: create(:user)) }

  context 'when site enabled' do
    it 'pinging http-service called' do
      expect(Client::HttpRequest)
        .to receive(:call).with(site.url).and_call_original

      described_class.call(site)
    end
  end

  context 'when site disabled' do
    it 'pinging http-service did not call' do
      expect(Client::HttpRequest)
        .not_to receive(:call).with(site.url).and_call_original

      site.enabled = false

      described_class.call(site)
    end
  end
end
