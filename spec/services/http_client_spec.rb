# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpClient do
  subject(:service_called) { described_class.call(site.full_url) }

  let(:site) { create(:site, user: create(:user)) }

  describe 'Service called' do
    context 'with response 100-300' do
      before { stub_valid_request(site.full_url, 200) }

      it 'returns success status' do
        expect(service_called).to include(status: 'success')
      end
    end

    context 'with response 400-500' do
      before { stub_valid_request(site.full_url, 500) }

      it 'returns failed status' do
        expect(service_called).to include(status: 'failed')
      end
    end

    context 'with errors' do
      before { stub_error_request(site.full_url) }

      it 'raises error' do
        expect(service_called).to include(status: 'errored', response_message: 'Exception from WebMock')
      end
    end
  end
end
