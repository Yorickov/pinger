# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  let(:url) { Faker::Internet.url }
  let(:checking_string) { Faker::String.random }

  before { stub_valid_request(url, 200) }

  context 'service called without options' do
    it 'calls http-client with empty options' do
      expect(HttpClient).to receive(:call).with(url, {}).and_call_original

      described_class.call(url)
    end
  end

  context 'service called with options' do
    let(:options) { { timeout: 5, checking_string: checking_string } }

    it 'calls http-client with service options' do
      expect(HttpClient).to receive(:call).with(url, options).and_call_original

      described_class.call(url, options)
    end
  end
end
