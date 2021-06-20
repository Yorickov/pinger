# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpClient do
  subject(:service_called) { described_class.call(url, options) }

  let(:url) { Faker::Internet.url }
  let(:options) { {} }
  let(:code_success) { 200 }
  let(:code_failed) { 500 }
  let(:checking_string) { Faker::Lorem.word }
  let(:random_string) { Faker::Lorem.word }
  let(:response_body) { "#{checking_string} #{Faker::Lorem.word}" }
  let(:exception_message) { 'Exception from WebMock' }

  describe 'Service called' do
    context 'with response 100-300' do
      before { stub_valid_request(url, code_success) }

      it 'returns success status' do
        expect(service_called).to include(status: described_class::STATUSES[:success])
      end
    end

    context 'with response 400-500' do
      before { stub_valid_request(url, code_failed) }

      it 'returns failed status' do
        expect(service_called).to include(status: 'failed')
      end
    end

    context 'when checking content found' do
      let(:options) { { checking_string: checking_string } }

      before { stub_valid_request(url, code_success, response_body) }

      it 'returns success status' do
        expect(service_called).to include(status: described_class::STATUSES[:success])
      end
    end

    context 'when checking content missing' do
      let(:options) { { checking_string: random_string } }

      before { stub_valid_request(url, code_success, response_body) }

      it 'returns success status' do
        expect(service_called).to include(status: described_class::STATUSES[:content_missing])
      end
    end

    context 'with errors' do
      before { stub_error_request(url, error_type) }

      context 'timeout error' do
        let(:error_type) { Faraday::TimeoutError }

        it 'returns timeout error status' do
          expect(service_called)
            .to include(status: described_class::STATUSES[:timeout_error], response_message: exception_message)
        end
      end

      context 'standart error' do
        let(:error_type) { StandardError }

        it 'returns errored status' do
          expect(service_called)
            .to include(status: described_class::STATUSES[:errored], response_message: exception_message)
        end
      end
    end
  end
end
