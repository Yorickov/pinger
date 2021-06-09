# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::HttpRequest do
  subject(:service_called) { described_class.call(site.full_url) }

  let(:site) { create(:site, user: create(:user)) }

  before { Timecop.freeze(Time.now.utc) }
  after { Timecop.return }

  describe 'Service called with any status' do
    before { stub_valid_request(site.full_url, 200) }

    it 'does not work if site is already pinging' do
      site.enabled = false

      expect { service_called }.not_to change(Log, :count)
    end
  end

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
